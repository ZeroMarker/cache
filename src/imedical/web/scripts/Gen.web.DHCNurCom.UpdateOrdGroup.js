function showWin(id){ if(parent&&parent.openEditWin){ parent.openEditWin(id);}}
document.body.onload=function(){
    runobj=document.getElementById("RunBtn");
    if (runobj){ runobj.onclick=runMethod ; }
}
function runMethod(){
    var tipHtml=document.getElementById("Tip").innerText;
    if(tipHtml.indexOf("参数")>-1){
        if(confirm(tipHtml+"仍旧运行？")==false)
            return false;
    }
    document.getElementsByClassName("torun")[0].innerHTML="";
    document.getElementsByClassName("runresult")[0].innerHTML="";
    var setSkinTest=document.getElementById("setSkinTest").value;
    var oreStr=document.getElementById("oreStr").value;
    var userId=document.getElementById("userId").value;
    var setExecFlag=document.getElementById("setExecFlag").value;
    var excuteAndPrintFlag=document.getElementById("excuteAndPrintFlag").value;
    var alertrunstr="w ##class(web.DHCNurCom).UpdateOrdGroup(\""+setSkinTest+"\",\""+oreStr+"\",\""+userId+"\",\""+setExecFlag+"\",\""+excuteAndPrintFlag+"\")";
    document.getElementsByClassName("torun")[0].innerHTML=alertrunstr;
    if (confirm("确认要运行 "+alertrunstr+ "吗？")==true){
        var rtn=tkMakeServerCall( "web.DHCNurCom", "UpdateOrdGroup",setSkinTest,oreStr,userId,setExecFlag,excuteAndPrintFlag);
        alert("运行结果:"+rtn);
        document.getElementsByClassName("runresult")[0].innerHTML=rtn;
        tkMakeServerCall( "websys.ComponentUtil", "SaveRunLog" , "Gen.web.DHCNurCom.UpdateOrdGroup" , alertrunstr , rtn );
        treload();
    }
}
