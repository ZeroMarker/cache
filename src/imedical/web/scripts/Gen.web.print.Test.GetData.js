function showWin(id){ if(parent&&parent.openEditWin){ parent.openEditWin(id);}}
document.body.onload=function(){
    runobj=document.getElementById("RunBtn");
    if (runobj){ runobj.onclick=runMethod ; }
}
function runMethod(){
    var tipHtml=document.getElementById("Tip").innerText;
    if(tipHtml.indexOf("����")>-1){
        if(confirm(tipHtml+"�Ծ����У�")==false)
            return false;
    }
    document.getElementsByClassName("torun")[0].innerHTML="";
    document.getElementsByClassName("runresult")[0].innerHTML="";
    var EpisodeID=document.getElementById("EpisodeID").value;
    var alertrunstr="w ##class(web.print.Test).GetData(\""+EpisodeID+"\")";
    document.getElementsByClassName("torun")[0].innerHTML=alertrunstr;
    if (confirm("ȷ��Ҫ���� "+alertrunstr+ "��")==true){
        var rtn=tkMakeServerCall( "web.print.Test", "GetData",EpisodeID);
        alert("���н��:"+rtn);
        document.getElementsByClassName("runresult")[0].innerHTML=rtn;
        tkMakeServerCall( "websys.ComponentUtil", "SaveRunLog" , "Gen.web.print.Test.GetData" , alertrunstr , rtn );
        treload();
    }
}
