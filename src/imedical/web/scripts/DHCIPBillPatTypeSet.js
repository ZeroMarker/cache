///DHCIPBillPatTypeSet.js 
///Creator:      Lid
///CreatDate:    2008-10-30
///Description:  病人费用类别配置业务
///Table:        DHC_JFSSGrpAdmReasonConfig
///Input:        grp:安全组ID?patType:病人类型ID?default:默认值      
///Return:       存在返回0?不存在返回1      

var SelectedRow = 0;
var CurRow=0,Str1="",Str2="",RowObj
var GroupDR;
//test
var x,y
var step=20
var flag=0
//TITLE
var objt=document.getElementsByTagName("TITLE");
var message=objt[0].innerHTML;
message=message.split("")
var xpos=new Array()
for (i=0;i<=message.length-1;i++) {
	xpos[i]=-50
}

var ypos=new Array()
for (i=0;i<=message.length-1;i++) {
	ypos[i]=-50
}
//引入样式表
document.write('<LINK REL="stylesheet" HREF="../scripts/customStyle1.css">');
//document.write('<script language="javascript" src="../scripts/MoveMouse.js"/>');
//window.setTimeout('move()',1000);

//test

function BodyLoadHandler() {
	
	var obj=document.getElementById('Add');
	if (obj) obj.onclick=Add_Click;
	
	var obj=document.getElementById('Delete');
	if (obj) obj.onclick=Delete_Click;
	
	//document.onmousemove=handlerMouse;
	//DefValueTag();
	var objt=document.getElementsByTagName("TITLE");
	objt.className="spanstyle";
	var obj=document.getElementById('update');
	if (obj) obj.onclick=Update_Click
	GroupDR = document.getElementById("UserGrp");
	var obj=document.getElementById('clear');
	if (obj) obj.onclick=Clear_Click;
	
	
}


function makesnake() {
	if (flag==1 && document.all) { 	   	
 	   	for (i=message.length-1; i>=1; i--) {
   			xpos[i]=xpos[i-1]+step
			ypos[i]=ypos[i-1]
	    	}
		xpos[0]=x+step
		ypos[0]=y
	
		for (i=0; i<message.length-1; i++) {
    			var thisspan = eval("span"+(i)+".style")
    			thisspan.posLeft=xpos[i]
			thisspan.posTop=ypos[i]
    		}
	}
	else if (flag==1 && document.layers) {
    		for (i=message.length-1; i>=1; i--) {
   				xpos[i]=xpos[i-1]+step
				ypos[i]=ypos[i-1]
    		}
		xpos[0]=x+step
		ypos[0]=y
	
		for (i=0; i<message.length-1; i++) {
    			var thisspan = eval("document.span"+i)
    			thisspan.left=xpos[i]
			thisspan.top=ypos[i]
    		}
	}
	var timer=setTimeout("makesnake()",30)
}

function handlerMouse()
{
//	move();
	x = (document.layers) ? e.pageX : document.body.scrollLeft+event.clientX
	y = (document.layers) ? e.pageY : document.body.scrollTop+event.clientY
	flag=1
	
	makesnake();
}

function move()
{
	for (i=0;i<=message.length-1;i++) {
    //document.write("<span id='span"+i+"' class='spanstyle'>")
	//document.write(message[i])
    //document.write("</span>")
	
	}
	if (document.layers){
	document.captureEvents(Event.MOUSEMOVE);
	}
	//document.onmousemove = handlerMM;
	// - End of JavaScript - -->
}
//美化界面 
function DefValueTag()
{
	
	var tb=tDHCIPBillPatTypeSet;
	
	//alert(tb.rows.length);
	for(var i=1;i<tb.rows.length;i++)
	{
		var cellObj=document.getElementById('defz'+i);
		//alert(cellObj.innerText);
		if(cellObj.innerText=="Y")
		{
			tb.rows[i].className="red";
		}
	}	
}


//添加
function Add_Click()
{
	var grp=document.getElementById('SSGrp').value
	var pattype=document.getElementById('PatType').value
	var deft=document.getElementById('Deft').checked
	var billNotPrintFlag=document.getElementById('BillNotPrint').checked //add by wanghuicai 2009-5-11
	
	//add 2009-8-4
	if(GroupDR.value=="")
	{
		GroupDR.value=document.getElementById('GrpRowId').value;
	}
	if(Str2=="")
	{
		Str2=document.getElementById('PatTypeRowId').value;
	}
	//end 2009-8-4
	if(GroupDR.value=="")
	{
		alert(t['01'])
	    return 
	}
	if(pattype=="")
	{
		alert(t['01'])
	    return     
	}
	if(Str2=="")
	{
		alert(t['01'])
	    return
	}
	if(deft){ 
		deft="Y"
	}
	else{
		deft="N"
	}
	if(billNotPrintFlag){ 
		var billNotPrint="Y"
	}
	else{
		var billNotPrint="N"
	} 
	
	//判断是否存在
	var getname1=document.getElementById('CheckGrp');
	if (getname1){var encmeth1=getname1.value}
	else{var encmeth1=''}
	var rstInfo=cspRunServerMethod(encmeth1,GroupDR.value,Str2,deft)
	var StrInfo=rstInfo.split("^")
	if(StrInfo[0]==0)
	{
		alert(t['05'])
	    return 
	}
	if(StrInfo[1]==0)
	{
		alert(t['06'])
		return
	}
	 //添加   
	var getname=document.getElementById('getAdd');
	if (getname){
		var encmeth=getname.value
	}
	else{
		var encmeth=''
	}
	
	var  rst=cspRunServerMethod(encmeth,GroupDR.value,Str2,deft,billNotPrint)
	 if(rst==0)
	 {
		alert(t['03'])
		Find_click();
		//DefValueTag();
	    return
	 }
	 else
	 {
	   alert(t['02'])
	   return
	   }
	}

//删除
function  Delete_Click()
{
	var getname=document.getElementById('getDel');
	if (getname)
	{
		var encmeth=getname.value
	}
	else 
	{
		var encmeth=''
	}
	var rowid=""
	if (CurRow==0)
    {
	    alert("请选择要删除的记录.")
	    return
	}
	//
	if(window.confirm('确定要删除吗?'))
    {
	   var SelRowObj=document.getElementById('rowidz'+CurRow)
       var ObjRoeId=SelRowObj.innerText
       var  rst=cspRunServerMethod(encmeth,ObjRoeId)
       Find_click();
    }
    	
}

function SelectRowHandler() 
{
	var eSrc = window.event.srcElement	
	//add 2009-8-4
	var objtbl=document.getElementById('tDHCIPBillPatTypeSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	//end
	var rowObj=getRow(eSrc)
	var Row=rowObj.rowIndex
	var selectrow=Row;
	if (Row==CurRow)
	{
		CurRow=0  
		return    
	}
	else
	{
		CurRow=Row
	}
	//2009-8-4
	if (!selectrow) return;
	var obj=document.getElementById('SSGrp');
	var obj1=document.getElementById('PatType');
	var obj2=document.getElementById('GrpRowId');
	var obj3=document.getElementById('PatTypeRowId');
	
	var SelRowObj=document.getElementById('SSGRPDescz'+selectrow);
	var SelRowObj1=document.getElementById('PatTypeDescz'+selectrow);	
	var SelRowObj2=document.getElementById('drpDrz'+selectrow);
	var SelRowObj3=document.getElementById('drpTypeDrz'+selectrow);
	
	obj.value=SelRowObj.innerText;
	obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.value;
	obj3.value=SelRowObj3.value;



	SelectedRow = selectrow;
	//end 2009-8-4
	
	var rowidObj=document.getElementById('rowidz'+CurRow)
	var TBillNotPrintObj=document.getElementById('TBillNotPrintz'+CurRow)
	var SSGRPDescObj=document.getElementById('SSGRPDescz'+CurRow)
	var PatTypeDescObj=document.getElementById('PatTypeDescz'+CurRow)
	var defObj=document.getElementById('defz'+CurRow)
		var SSGrpObj=obj; //var SSGrpObj=websys_$('SSGrp') ;  //modified by ytq on 20090825
	if (SSGrpObj) SSGrpObj.value=SSGRPDescObj.innerText ;  //added if by ytq on 20090825
	GroupDR.value=tkMakeServerCall("web.DHCIPBillPatTypeSet","GetgrpidBYname", SSGrpObj.value);  //add zhangli  17.7.24
	if (PatTypeObj){//added if by ytq on 20090825
		var PatTypeObj=document.getElementById('PatType');  //websys_$('PatType') ; //modified by ytq on 20090825
		PatTypeObj.value=PatTypeDescObj.innerText;
	}
	var DeftObj=  document.getElementById('Deft') //websys_$('Deft')	; //modified by ytq on 20090825
	if (DeftObj){//added if by ytq on 20090825
		if(defObj.innerText=='Y'){
			DeftObj.checked="checked";
		}else{
			DeftObj.checked="";
		}
	}
	var BillNotPrintObj=document.getElementById('BillNotPrint');
	if (BillNotPrintObj){ //added if by ytq on 20090825
		if (TBillNotPrintObj){ //added if by ytq on 20090825
			if(TBillNotPrintObj.innerText=='Y'){
				BillNotPrintObj.checked="checked";  //websys_$('BillNotPrint').checked="checked";  //modified by ytq on 20090825
			}else{
				BillNotPrintObj.checked=""; //websys_$('BillNotPrint').checked="";//modified by ytq on 20090825
			}
		}
	}
	
	//rowObj.Class="eee"
	//rowObj.className="red"
	//alert(rowObj.Class)
	//alert(rowObj.className)
}

//得到值
function GetGrpRowId(Value)
{
	//add 2009-8-4
	var obj=document.getElementById('GrpRowId')
	var TmpStr=Value.split("^")
	//alert(TmpStr);
	GroupDR.value=TmpStr[1];
}
function GetPatTypeRowId(Value)
{
	//add 2009-8-4
	var obj=document.getElementById('PatTypeRowId')
	var TmpStr=Value.split("^")
	Str2=TmpStr[1]
}



//更新 wanghuicai
function Update_Click()
{   
    if (CurRow==0)
    {
	    alert("请选择更新记录.")
	    return
	}
	var grp=document.getElementById('SSGrp').value
	var pattype=document.getElementById('PatType').value
	var deft=document.getElementById('Deft').checked
	var billNotPrintFlag=document.getElementById('BillNotPrint').checked
	if(deft){ 
		deft="Y"
	}
	else{
		deft="N"
	}
	if(billNotPrintFlag){ 
		var billNotPrint="Y"
	}
	else{
		var billNotPrint="N"
	} 
	if(GroupDR.value=="")
	{
		GroupDR.value=document.getElementById('GrpRowId').value;
	}
	if(Str2=="")
	{
		Str2=document.getElementById('PatTypeRowId').value;
	}
	var getname1=document.getElementById('CheckGrp');
	if (getname1){var encmeth1=getname1.value;}
	else{var encmeth1='';}
	var rstInfo=cspRunServerMethod(encmeth1,GroupDR.value,Str2,deft);
	var StrInfo=rstInfo.split("^");
	if(StrInfo[0]==0)
	{
		alert(t['05']);
		return;
	}
	if(StrInfo[1]==0)
	{
		alert(t['06']);
		return;
	}
	var SelRowObj=document.getElementById('rowidz'+CurRow)
    var ObjRoeId=SelRowObj.innerText
	var updateEncryptObj=document.getElementById('PrintEncrypt');
	if (updateEncryptObj){
		var encmeth=updateEncryptObj.value
	}
	else{
		var encmeth=''
	}
	var  rst=cspRunServerMethod(encmeth,ObjRoeId,grp,pattype,deft,billNotPrint)
	if(rst==0)
	{
		alert(t['updateSucc'])
		Find_click();
	}
	 else
	 {
	   alert(t['updateFail'])
	   return
    }
    
}
/*function old_Clear_Click()
{
	websys_$('Deft').checked="";
	websys_$('BillNotPrint').checked="";
	websys_$('SSGrp').value="";
	websys_$('PatType').value="";
	websys_$('UserGrp').value="";

}
*/
//add 2009-8-4
function Clear_Click()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPatTypeSet";
	window.location.href=lnk;
}

document.body.onload = BodyLoadHandler

