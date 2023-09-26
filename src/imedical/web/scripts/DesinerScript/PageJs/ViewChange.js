var selViewId = null;

$(document).ready(function() {
    $("td[name = 'viewItem']").click(changeView);
    $("td[name = 'viewItem']").mouseover(viewItem_Over);
    $("td[name = 'viewItem']").mouseout(viewItem_Out);
    selViewId = "tdDesiner";
});

function changeView() {
    selViewId = event.srcElement.id;
    $("td[name = 'viewItem']").removeClass();
    $("td[name = 'viewItem']").addClass("viewItemNormal");
    $("#" + selViewId).removeClass();
    $("#" + selViewId).addClass("viewItemSel");
    switch (selViewId) {
        case "tdDesiner":
            parent.frLayout.showDisiner();
            break;
        case "tdXml":
            parent.frLayout.showXml();
            break;
    }
}

function viewItem_Over(){
    $(this).removeClass();
    $(this).addClass("viewItemMoveOver");
}

function viewItem_Out(){
    $(this).removeClass();
    if (selViewId != event.srcElement.id) {
        $(this).addClass("viewItemNormal");
    }
    else {
        $(this).addClass("viewItemSel");
    }
}