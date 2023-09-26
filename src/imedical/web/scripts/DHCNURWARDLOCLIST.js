function BodyLoadHandler()
{
}

 function SelectRowHandler()
{
    var i;
    var selrow=document.getElementById("SelRow");
    selrow.value=DHCWeb_GetRowIdx(window);
    var LocId=document.getElementById("LocIdz"+selrow.value).value;
    var WardId=document.getElementById("WardIdz"+selrow.value).value;
    var ward=document.getElementById("PacWardz"+selrow.value).innerText;
    var Loc=document.getElementById("Locz"+selrow.value).innerText;
    var pacward= parent.frames[0].document.getElementById("PacWard");
    var pacwardid=parent.frames[0].document.getElementById("WardId");
    var dep=parent.frames[0].document.getElementById("Loc");
    var depid=parent.frames[0].document.getElementById("LocId");
    pacward.value=ward;
    pacwardid.value=WardId;
    dep.value=Loc;
    depid.value=LocId;
   // var rw=document.getElementById("seleitemz"+selrow);//arcimDesc
}
document.body.onload = BodyLoadHandler;