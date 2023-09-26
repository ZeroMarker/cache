function InitEvents() 
{
    var tables = document.getElementsByTagName("table");
    for (var j = 1; j < tables[1].rows.length; j++) {
        var objLoc = document.getElementById("TDischLocDescz" + j);
        if (objLoc != null && objLoc.innerText != "------") {
            tables[1].rows[j].style.backgroundColor = "hotpink";
        }
    }
}

InitEvents();