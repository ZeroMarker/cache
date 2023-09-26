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
    var EpisodeID=document.getElementById("EpisodeID").value;
    var alertrunstr="w ##class(web.print.Test).GetData(\""+EpisodeID+"\")";
    document.getElementsByClassName("torun")[0].innerHTML=alertrunstr;
    if (confirm("确认要运行 "+alertrunstr+ "吗？")==true){
        var rtn=tkMakeServerCall( "web.print.Test", "GetData",EpisodeID);
        alert("运行结果:"+rtn);
        document.getElementsByClassName("runresult")[0].innerHTML=rtn;
        tkMakeServerCall( "websys.ComponentUtil", "SaveRunLog" , "Gen.web.print.Test.GetData" , alertrunstr , rtn );
        treload();
    }
}
