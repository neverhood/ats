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
            var menuLabel = itemData.label
            var menuIcon = "/images/" + menuLabel.toLowerCase().replace(" ", "_") + ".png"
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