var RowidValue="",Content,Solution,User,Desc
var username=session['LOGON.USERNAME']
function BodyLoadHandler(){
	//alert("111")
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=Update_Click;}
	var obj=document.getElementById("ADD");
	if (obj){obj.onclick=add_Click;}
    var obj=document.getElementById("Delete");
	if (obj) {obj.onclick=Delete_Click;}
	var	obj=document.getElementById("find")
	if (obj){obj.readOnly=true;}
	//var obj=document.getElementById("COMMfujian");
	//if (obj){obj.onclick=COMMfujian_click;}
		//var obj=document.getElementById("COMMNew");
	//if (obj){ obj.onclick=COMMNew_click;}
}	
/*********************增加********************************/

function add_Click()
{
    var lnk ="websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogChild&User="+username;
    window.location.href=lnk;
}

/*********************更新********************************/
function Update_Click()
{
	
	//var encmeth=document.getElementById("SaveParaEncrypt").value;
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogChild1&Rowid="+RowidValue+"&Content="+Content+"&Solution="+Solution+"&User="+User+"&Desc="+Desc;
   
     window.open('websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogChild1&Rowid='+RowidValue+'&Content='+Content+'&Solution='+Solution+'&User='+User+'&Desc='+Desc, '更新工作记录', 'resizable=yes,height=350,width=650,top=150,left=350');
    //window.location.href=lnk;
}
 /*********************删除********************************/
function Delete_Click()
{
    //var MURowid=document.getElementById("Rowid").value;
	//alert(RowidValue);
	//alert()
	if(RowidValue==""){
		alert(t["del"]);
		return;}
		else{
  	var Del=document.getElementById('Dle');
	var str=tkMakeServerCall("web.PMPJobLogging","deleteJobLogging",RowidValue)
	alert(t["delreturn"]);
	var StDate=document.getElementById("StDate").value;
	var EnDate=document.getElementById("EndDate").value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=PMPJobLogging&StDate="+StDate+"&EndDate="+EnDate;
    window.location.href=lnk;
		}
}
 
/*********************选择一行数据********************************/	
function SelectRowHandler()	
{
	var eSrc=window.event.srcElement;
	objtbl=document.getElementById('tPMPJobLogging');
	var rows=objtbl.rows.length;
	var rowObj=getRow(eSrc);
	//alert(rows);
	selectrow=rowObj.rowIndex;
	//alert(selectrow);
	
	var SelRowObj=document.getElementById('Date1z'+selectrow);
	
	Date1=SelRowObj.innerText;
	
	var SelRowObj1=document.getElementById('Timez'+selectrow);
	Time=SelRowObj1.innerText;
	var SelRowObj2=document.getElementById('Userz'+selectrow);
	User=SelRowObj2.innerText;
	var SelRowObj3=document.getElementById('Contentz'+selectrow);
	Content=SelRowObj3.innerText;
    var SelRowObj4=document.getElementById('Descz'+selectrow);
    Desc=SelRowObj4.innerText;
    var SelRowObj5=document.getElementById('Solutionz'+selectrow);
    Solution=SelRowObj5.innerText;
    var SelRowObj6=document.getElementById('SolutionDatez'+selectrow);
    SolutionDate=SelRowObj6.innerText;
    var SelRowObj7=document.getElementById('SolutionTimez'+selectrow);
    SolutionTime=SelRowObj7.innerText;
     
    var obj=document.getElementById('Rowidz'+selectrow);
    RowidValue=obj.value;
   
	var Obj1=document.getElementById('Date1');
	if(Obj1) Obj1.value=Date1;
	var obj10=document.getElementById('JLRowid');
	if(obj10) obj10.value=RowidValue;
	var Obj2=document.getElementById('Time');
	if(Obj2) Obj2.value=Time;
	
	var Obj3=document.getElementById('User');
	if(Obj3) Obj3.value=User;
	
	var Obj4=document.getElementById('Content');
	if(Obj4) Obj4.value=Content;
	
	var Obj5=document.getElementById('Desc');
	if(Obj5) Obj5.value=Desc;
	
	var Obj6=document.getElementById('Solution');
	if(Obj6) Obj6.value=Solution;
	
	var Obj7=document.getElementById('SolutionDate');
	if(Obj7) Obj7.value=SolutionDate;	
	
	var Obj8=document.getElementById('SolutionTime');
	if(Obj8) Obj8.value=SolutionTime;
	
	 var obj9=document.getElementById('downloadz'+selectrow);
  	 if (obj9){obj9.onclick=TYPAccessory_click;}
  	
}
/*********************附件下载********************************/	
 
function TYPAccessory_click()
{

	var obj=document.getElementById('JLRowid');

	if(obj.value!="")
	{
		rowid=obj.value;
		var VerStr=tkMakeServerCall("web.PMP.PMPImprovementList","selectPMPIImprovementAdjunct",rowid,"Improvement");
		
		if (VerStr=="") {
			alert("对不起，客户未上传附件！");
			return;
			}
		VerStr=VerStr.split("^");
		var No=VerStr.length
		alert("213="+VerStr)
		if(VerStr!="")
		{	
			for(i=0;i<=VerStr.length-1;i++)
			{  
			   VerStrName=VerStr[i].split(",");
			   name=VerStrName[1]
			   BrowseFolder(name)
			   var VerStrsinn=tkMakeServerCall("web.PMPJobLogging","single",VerStrstr);
				aa="copy "+VerStrName[0]+" "+VerStrsinn;
				Log(aa)
			}
		}
    }
    else {alert(t["1"])}
}
document.body.onload=BodyLoadHandler;