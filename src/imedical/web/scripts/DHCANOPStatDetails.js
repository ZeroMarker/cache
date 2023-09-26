// JavaScript Document
function BodyLoadHandler()
{   
    var objtbl=document.getElementById('tDHCANOPStatDetails');
    var i;
    var firstEsrc=objtbl.rows[1]
    var lastEsrc=objtbl.rows[objtbl.rows.length-1];
    var firstRowObj=getRow(firstEsrc);
    firstRowObj.className="Temp";
    var lastRowObj=getRow(lastEsrc);
    lastEsrc.className="Immediate";
}
document.body.onload = BodyLoadHandler;
