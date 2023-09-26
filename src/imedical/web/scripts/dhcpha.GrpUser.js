var parwin;
var selectRow;
function BodyLoadHandler()
{
	parwin=window.dialogArguments;
	var obj=document.getElementById("OK")
	if (obj)  obj.onclick=setUser;
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=closeWin;
	//var str=parwin.GetListStr();
	//if (str!="") setSelected(str);
}
function closeWin(){
   window.close();
}
function SelectRowHandler(){
	selectRow=selectedRow(window);
}
function setUser(){
	if (selectRow==""){
		alert("请选择人员!")
		return;
	}
	var obj1=document.getElementById("rowid"+"z"+selectRow);
	var obj2=document.getElementById("UserId"+"z"+selectRow);
	var obj3=document.getElementById("UserName"+"z"+selectRow);
	var rowid=obj1.value;
	var userId=obj2.innerText;
	var userName =obj3.innerText;
	var datas=rowid+"^"+userId+"^"+userName;
	var parDocument=parwin.document;
	var obj=parDocument.getElementById("collectorStr");
	if (obj)
	obj.value=datas;
	parwin.setCollectorList();  //主窗口函数
	closeWin();
}
/// 多选,但是多选没用,最后只存了一个
function setUserOld()
{
	var datas="";	
	var tab=document.getElementById('t'+'dhcpha_GrpUser')
	if (tab)
	{
	  var rowCount=getRowcount(tab);
	
	  for (var i=1;i<=rowCount;i++)		
		{
		  var rowSelect=document.getElementById("select"+"z"+i);
		  var obj1=document.getElementById("rowid"+"z"+i);
		  var obj2=document.getElementById("UserId"+"z"+i);
		  var obj3=document.getElementById("UserName"+"z"+i);
		  
		  
		  if (rowSelect)
		  {
			  if (rowSelect.checked) 
			  
		 		{
			 		var rowid=obj1.value;
			 		var userId=obj2.innerText;
			 		var userName =obj3.innerText;
			 		
			 		if (datas=="")
			 		{datas=rowid+"^"+userId+"^"+userName}
			 		else
			 		{datas=datas+"!"+rowid+"^"+userId+"^"+userName}
			 		}
			  
			  }
		}	
	}
	
	
	//var parDocument=window.opener.document ;
	
	var parDocument=parwin.document;
	
	var obj=parDocument.getElementById("collectorStr");
	if (obj)
	obj.value=datas;
	parwin.setCollectorList();  //主窗口函数
	//window.returnValue=datas;
	closeWin();
}

function setSelected(str)
{
  var ss=str.split("^");
  var obj=document.getElementById("t"+"dhcpha_GrpUser")
  var rowcount=getRowcount(obj);
  for (i=0;i<ss.length;i++)
  {
	  var rowid=ss[i];
	  for (j=1;j<rowcount;j++)
	  {
		  var currRowid=document.getElementById("rowid"+"z"+j) ;
		  if (currRowid.value==rowid)
		  {
			  var currSelect=document.getElementById("select"+"z"+j) ;
			  currSelect.checked=true;
			  }
		  }
	  }
}
document.body.onload=BodyLoadHandler;
//document.body.onunload= BodyUnLoadHandler 
