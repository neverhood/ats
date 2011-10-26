// Quick (yet pretty much solid) sorting feature

jQuery.fn.sortElements = (function(){

    var sort = [].sort;

    return function(comparator, getSortable) {

        getSortable = getSortable || function(){return this;};

        var placements = this.map(function(){

            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,

                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );

            return function() {

                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }

                parentNode.insertBefore(this, nextSibling);
                parentNode.removeChild(nextSibling);

            };

        });

        return sort.call(this, comparator).each(function(i){
            placements[i].call(getSortable.call(this));
        });

    };

})();

String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g,"");
};

Array.prototype.equals = function(array) {
    var result = true;

    for ( element in this ) {
        if ( this[element] != array[element] ) {
            result = false;
            break;
        }
    }

    return result;
};

function invert( object ) {
    var inverted = {};

    for ( var key in object ) inverted[ object[key] ] = key;
    return inverted;
}

var menus = {};
function redirect(href) {
    return  function() {
        window.location.href = href
    }
}
$(document).ready(function() {
    $(function() {
        //show flash
        showFlash();

        //init filter box if any
        initFilterBox();

        //setup context menu for table records
        setupContextMenus()

        //update sites status
        runSiteStatusUpdater();

        runSiteRowUpdater();
    });

    // API

    $.api = {
        columnsMapping: {
            straight: {},
            inverted: {}
        },
        latestSort: '',
        utils: {

            // tableColumn returns an object with #header and #elements properties, representing the entire column
            tableColumn: function( header ) {
                var table = $('.db_table'),
                    columnNumber,
                    columnElements = [],
                    columnHeader;

                $.each( table.find('th'), function(index, element) {
                    if ( $(element).attr('data-header') == header ) {
                        columnNumber = index + 1;
                        columnHeader = $(element);
                    }
                });

                if ( columnHeader ) {
                    columnElements = table.find('td:nth-child(' + columnNumber + ')');
                    return { header: columnHeader, elements: columnElements };
                } else { // Report has been generated without this column
                    return null;
                }
            },

            includedReportColumns: function() {
                var columns = [];

                $.each( $('#selected-columns div.column-header'), function() {
                    var header = $.api.columnsMapping.inverted[ $(this).attr('id') ];
                    columns.push( $.api.utils.tableColumn( header ) );
                });
                return columns;
            },

            hideColumn: function( column ) {
                column.header.hide();
                column.elements.hide();
            },

            showColumn: function( column ) {
                column.header.show();
                column.elements.show();
            },

            tableColumnsOrder: function() {
                return $.map( $('.db_table th'), function(element) {
                    return $(element).attr('data-header');
                })
            },

            tableVisibleColumnsOrder: function() {
                return $.map( $('div#selected-columns .column-header'), function(element) {
                    return $.api.columnsMapping.inverted[ $(element).attr('id') ];
                })
            },

            rebuildTable: function() {
                var reportRows = $('table.db_table tr').toArray(),
                    columns = $.api.utils.includedReportColumns();

                reportRows.shift(); // Remove header

                $.each( columns.reverse(), function() {

                    if ( !this.header.is(':visible') ) $.api.utils.showColumn(this);

                    $('table.db_table #table-header').prepend( this.header );
                    var elements = this.elements.toArray();

                    $.each( reportRows, function() {
                        $(this).prepend( elements.shift() );
                    });
                });
            },

            buildDummyFilter: function() {
                var filter = $('div.filter').first().clone();

                filter.find('.column').val('ref_code');
                filter.find('.type').val('is_null');
                filter.find('.value').hide().val('');

                return filter;
           }
        }
    };

// Drag`n`drop

    if ( $('table.db_table').length ) {
        var table = $('table.db_table'),
            columnsOrder = $.api.utils.tableColumnsOrder();

        $.each( columnsOrder, function( index, id ) {
            var columnIndex = index + 1;
            $.api.columnsMapping.straight[ id ] = 'column-' + columnIndex;
        });

        $.api.columnsMapping.inverted = invert( $.api.columnsMapping.straight );
    }

    $.api.utils.sortTableHandler = {
        helperCells: null,
        items: '>:not(.nosort)',
        placeholder: 'placeholder',
        handle: '.drag-handle',
        stop: function() {
            var columnsOrder =  $.api.utils.tableColumnsOrder(),
                selectedColumns = $('div#selected-columns');

            $.each( columnsOrder.reverse(), function(index, id)  {
                var selector = 'div#' + $.api.columnsMapping.straight[ id ];

                $('#selected-columns').
                    prepend( selectedColumns.find( selector ) );
            });
        }
    };

    $('.db_table').sorttable( $.api.utils.sortTableHandler );
    $('.db_table th').disableSelection();

    $('div#selected-columns, div#available-columns').sortable({
        connectWith: '.connectedSortable',
        start: function(event, ui) {
            ui.item.data('dragged-from', ui.item.parent().attr('id') );
        },
        update: function(event, ui) {
            var column = ui.item.text().trim(),
                sender = $('#' + ui.item.data('dragged-from')),
                columnHeader = $.api.columnsMapping.inverted[ ui.item.attr('id') ];

            // user wants column to be excluded
            if ( sender.attr('id') == 'selected-columns' && ui.item.parent().attr('id') == 'available-columns' ) {
                $.api.utils.hideColumn( $.api.utils.tableColumn( columnHeader ) );
            } else {
                // user wants column to be included or changes the columns order

                if ( $.api.utils.tableColumn( columnHeader ) ) {
                    $.api.utils.rebuildTable();
                } else {
                    // Table has been built without this column, going to get info from server
                    console.log(' implement an ajax ')
                }
            }
        }
    }).disableSelection();

    $('table.db_table th').live('click', function() {
        var table = $('table.db_table'),
            $this = $(this),
            thIndex = $this.index(),
            inverse;

        if ( $(this).hasClass('accept') ) {
            if ( $.api.latestSort == $this.attr('data-header') ) {
                inverse = !$this.data('inverse');
            } else {
                inverse = false;
            }

            table.find('td').filter(function() {
                return $(this).index() === thIndex;
            }).sortElements(function(a, b) {

                    if ( !/(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} UTC)/.test(a.innerText) && parseInt(a.innerText) && parseInt(b.innerText) ) {

                        return parseInt(a.innerText) > parseInt(b.innerText) ?
                            inverse ? -1 : 1
                            : inverse ? 1 : -1;
                    } else {
                        return $.text([a]) > $.text([b]) ?
                            inverse ? -1 : 1
                            : inverse ? 1 : -1;
                    }

                }, function() {
                    return this.parentNode;
                });

            $this.data('inverse', inverse);

        $('#results_order_by').val( $this.attr('data-header') );
        $('#results_order_direction').val( inverse? 'desc' : 'asc' );

            $('table.db_table th').removeClass('desc asc');
            $this.addClass( inverse? 'desc' : 'asc' );

            $.api.latestSort = $this.attr('data-header');
        }
    });


    $('form#customize-table').bind('submit', function() {
        $('#results_fields').val( $.api.utils.tableVisibleColumnsOrder().join(',') );
    }).
        bind('ajax:complete', function(event, xhr, status) {
            if ( status == 'success' ) {
                $('#db-table-placeholder').html( $.parseJSON(xhr.responseText).table );
            }
        });

        // * Filters *

    $('div.filter .type').live('change', function() {
        var filterValueField = $(this).parents('div.filter').find('.value');

        if ( this.value == 'is_null' || this.value == 'is_not_null' ) {
            filterValueField.val('').hide();
        } else {
            filterValueField.show();
        }
    });

    $('#add-new-filter').click(function() {
        if ( $('#active-filters div.filter:visible').length > 0 ) {
            var newFilter = $.api.utils.buildDummyFilter();

            $('#active-filters').append( newFilter );
        } else {
            $('div.filter').show();
        }
    });

    $('.remove-filter').live('click', function() {
        var newFilter = $.api.utils.buildDummyFilter();
        $(this).parents('div.filter').remove();

        if ( $('div.filter').length == 0 ) {
            $('#active-filters').append( newFilter.hide() );
        }
    });

});

function showFlash() {
    $(".flash").toggle("drop", 300, function() {
        setTimeout('$(".flash").fadeOut(700);', 5000)
    });
}
function initFilterBox() {
    var ft = $("#filter_trigger");
    if (ft) {
        ft.click(function() {
            $("#filter").toggle("highlight", 500);
        })
    }
}
function setupContextMenus() {
    for (var id in menus) {
        var menuData = menus[id];
        var menu = [];
        var menuItem = {};
        /** @namespace menuData.items */
        for (var j = 0; j < menuData.items.length; j++) {
            var itemData = menuData.items[j];
            var menuLabel = itemData.label;
            var menuIcon = "/images/" + menuLabel.toLowerCase().replace(" ", "_") + ".png";
            menuItem[menuLabel ] = {  onclick:redirect(itemData.href), icon:menuIcon};
            menu.push(menuItem);
            menuItem = {};
        }
        // dbg(menu, "M")
        $('#' + id).contextMenu(menu, {theme:'vista', trigger_id:id});
    }
}
function runSiteRowUpdater() {
    var siteRows = $("tr[site_id]");
    for (var i = 0; i < siteRows.length; i++) {
        var $row = $(siteRows[i]);
        var site_id = $row.attr("site_id")
        if (site_id) {
            updateSiteRow(site_id);
        }
    }
}
function updateSiteRow(site_id) {
    var $row = $("tr[site_id='" + site_id + "']");
    if (site_id) {
        $row.load("/sites/" + site_id + "/row", function() {
            setupContextMenus();
            setTimeout("updateSiteRow( " + site_id + "  )", 50000);
        });
    }
    //dbg(Object.keys(menus).length, "M: " + site_id);
}
function runSiteStatusUpdater() {
    var $cells = $("span[site_id]");
    for (var i = 0; i < $cells.length; i++) {
        var $cell = $($cells[i]);
        var site_id = $cell.attr("site_id")
        if (site_id) {
            updateSiteStatus(site_id);
        }
    }
}
function updateSiteStatus(site_id) {
    var $cell = $("span[site_id='" + site_id + "']");
    if (site_id) {
        $cell.load("/sites/" + site_id + "/status", function() {
            setSiteStatusClass($cell)
            setTimeout("updateSiteStatus( " + site_id + "  )", 50000);
        });
    }
}
function setSiteStatusClass($cell) {
    var cls = "site_status ";
    var cls2 = ""
    var text = $cell.text();
    text = text.trim();
    switch (text) {
        case "idle":
            cls2 = "site_idle";
            break;
        case "unknown":
        case "":
            cls2 = "site_unknown";
            break;
        default :
            if (text.match(/.*error.*/)) {
                cls2 = "site_error";
            } else {
                cls2 = "site_running";
            }
            break;
    }
    cls += cls2;

    $cell.removeClass();
    $cell.addClass(cls);
}
function kill($el) {

}
function reenableRunButton() {
    var input = $("#site_status").val("idle");
    dbg(input.length, "ST")
}
