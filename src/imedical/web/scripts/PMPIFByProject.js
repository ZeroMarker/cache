//PMPIFByProject.js
function BodyLoadHandler(){//PMPIFByProject.js
    document.getElementById("CreatUserID").value=""
    document.getElementById("PJURowid").value=""
}
function SelectRowHandler() 
{
    var eSrc=window.event.srcElement;
    objtbl=document.getElementById('tPMPImprovementFindByProject');
    var rows=objtbl.rows.length;
    var rowObj=getRow(eSrc);
    //alert(rows);
    selectrow=rowObj.rowIndex;
    
    var SelRowObj=document.getElementById('IPMLRowidz'+selectrow);
    document.getElementById("IPMLRowid").value=SelRowObj.innerText;
    var SelRowObj1=document.getElementById('IPMDRowidz'+selectrow);
    document.getElementById("IPMDRowid").value=SelRowObj1.innerText; 
}

function PJURowidGetFind(value){
    var info=value.split("^");
    document.getElementById("PJURowid").value=info[1];
}

function creatuserFind(value){
    var info=value.split("^");
    document.getElementById("CreatUserID").value=info[1];
}

function pass(IPMLRowid,IPMDRowid){
    //var IPMLRowid=document.getElementById("IPMLRowid").value;
    //var IPMDRowid=document.getElementById("IPMDRowid").value;
    var PJURowid=document.getElementById("PJURowid").value;
    if((IPMLRowid!="")&&(IPMDRowid!="")){
        var value;
        value=tkMakeServerCall("web.PMP.PMPImprovementCheck","passByProject",IPMLRowid,IPMDRowid,PJURowid);
        if (value!=1){
            alert("后台程序发生异常！")
        }
        var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByProject";
        window.location.href=lnk;
    }
}
function reject(IPMLRowid,IPMDRowid){
    //var IPMLRowid=document.getElementById("IPMLRowid").value;
    //var IPMDRowid=document.getElementById("IPMDRowid").value;
    var rejectRea=prompt("请填写拒绝原因","");
    if(rejectRea==""){
        alert("拒绝原因不能为空!");
    }else if((IPMLRowid!="")&&(IPMDRowid!="")){
        value=tkMakeServerCall("web.PMP.PMPImprovementCheck","rejectByProject",IPMLRowid,IPMDRowid,rejectRea);
        if (value==2){
            alert("拒绝原因不能为空!")
        }else if(value!=1&&value!=2){
            alert("后台程序发生异常！")
        }        
    }
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByProject";
    window.location.href=lnk;
}

document.onload=BodyLoadHandler();