var dbgLevel = 0;
var adminDebug = true;

var dbgOptions = {
    LevelMax: 5,
    HideTooDeepMsg: true ,
    NoFollowNodes: ["_firebug", "FB", "console", "window", "sessionStorage", "globalStorage", "view"]  ,
    HideFunctions:false
};


function dbg(obj, lbl, err, options) {
    var cfg = jQuery.extend({},dbgOptions, options)
    if (!lbl)lbl = "lbl";
    if (! window.console && adminDebug) {
        alert("No window.console\n" + lbl + ":" + obj);
        adminDebug = false;
        return;
    }
    if (! adminDebug) return;
    if (dbgLevel > cfg.LevelMax) {
        if (!cfg.HideTooDeepMsg) {
            console.log(lbl + "[ too deep ]");
        }
        dbgLevel --;
        return;
    }


    if (typeof(obj) == "object") {
        console.log(lbl + ":");
        for (var i in obj) {

            if (obj.hasOwnProperty(i)) {
                dbgLevel++;
                var lbl2 = i;
                for (var indent = 0; indent < dbgLevel; indent++) {
                    lbl2 = " | " + lbl2;
                }
                try {
                    var nestedObj = obj[i];
                    if ($.inArray(i, cfg.NoFollowNodes) > -1) {
                        nestedObj = "_FOLLOWING_PROHIBITED_";
                    }
                    dbg(nestedObj, lbl2, err);
                } catch(e) {
                    console.error("ERROR[" + lbl2 + "]" + e.toString());
                }
            }
        }
    } else {
        if (err) {
            console.error(lbl + ":" + obj);
        } else {
            if ($.isFunction(obj) && cfg.HideFunctions) {
                obj = "__FUNCTION__"
            }
            console.log(lbl + ":" + obj);
        }
    }

    dbgLevel--;
    if (dbgLevel < 0) {
        dbgLevel = 0;
        console.log("-------");
    }
}		