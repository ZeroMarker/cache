//DHCDocDiagnosSignSymptom.js
var SelectedRow = 0;

function DocumentLoadHandler() 
{  
  	var obj=document.getElementById('add')
	if(obj) obj.onclick=add_click;
	var obj=document.getElementById('update')
	if(obj) obj.onclick=update_click;
	var obj=document.getElementById('del')
	if(obj) obj.onclick=del_click;
	var obj=document.getElementById('blank')
	if(obj) obj.onclick=blank_click;
	var obj=document.getElementById('DSYMAActiveInActive');
	if(obj) {
		obj.options.size=1;
		obj.options.multiple=false;
		obj.options[0]=new Option("Y","Y");
		obj.options[1]=new Option("N","N");
	}
	var obj=document.getElementById('DSYMACTLOCDR')
	if(obj) obj.onchange=LocChangeHandle;
	
}
function blank_click(){
	var obj=document.getElementById('DSYMARowId');
	obj.value="";
	var obj=document.getElementById('DSYMACode');
	obj.value=""
	var obj=document.getElementById('DSYMADesc');
	obj.value=""
	var obj=document.getElementById('DSYMACTLOCDR');
	obj.value=""
	var obj=document.getElementById('DSYMADateFrom');
	obj.value=""
	var obj=document.getElementById('DSYMADateTo');
	obj.value=""
	var obj=document.getElementById('ctloc')
	obj.value=""
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
//选择table中的某一行	
function SelectRowHandler(){
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocDiagnosSignSymptom');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelectedRow!=selectrow){
	var obj=document.getElementById('DSYMARowId');
	var obj1=document.getElementById('DSYMACode');
	var obj2=document.getElementById('DSYMADesc');
	var obj3=document.getElementById('DSYMACTLOCDR');
	var obj4=document.getElementById('DSYMADateFrom');
	var obj5=document.getElementById('DSYMADateTo');
	var obj6=document.getElementById('DSYMAActiveInActive');
	var obj8=document.getElementById('ctloc');
	//判断code唯一性的隐藏元素
	var obj9=document.getElementById('CodeUnquie');
	 obj9.value=""
	//取table中选中的某行的值
	var SelRowObj=document.getElementById('TDSYMRowIdz'+selectrow);
	var SelRowObj1=document.getElementById('TDSYMCodez'+selectrow);
	var SelRowObj2=document.getElementById('TDSYMDescz'+selectrow);
	var SelRowObj3=document.getElementById('TDSYMCTLOCDRz'+selectrow);
	var SelRowObj4=document.getElementById('TDSYMDateFromz'+selectrow);
	var SelRowObj5=document.getElementById('TDSYMDateToz'+selectrow);
	var SelRowObj6=document.getElementById('TDSYMActiveInActivez'+selectrow);
	var SelRowObj7=document.getElementById('CTLocidz'+selectrow);
	//将取到的table中选中的列值赋值给对应属性的编辑框
	if (obj) obj.value=SelRowObj.value;
	if (obj1)obj1.value=SelRowObj1.innerText;
	if (obj9)obj9.value=SelRowObj1.innerText;
	if (obj2)obj2.value=SelRowObj2.innerText;
	if (obj3)obj3.value=SelRowObj3.innerText;
	if (obj4)obj4.value=Trim(SelRowObj4.innerText);
	if (obj5)obj5.value=Trim(SelRowObj5.innerText);
	var effectflag=SelRowObj6.innerText;
	if (obj6&&obj6.length>0)
	{
		if(effectflag!=""&&effectflag=="Y"){obj6.options[0].selected=true;}
		else {obj6.options[1].selected=true;}
	}
	if (obj8){
		obj8.value=Trim(SelRowObj7.value);
	}
	SelectedRow=selectrow;
	}else{
		SelectedRow=0
		var obj=document.getElementById('DSYMARowId')
		if(obj) {obj.value="";}
		blank_click()
	}
	return;
}
//新增症状信息
function add_click()
{
	var obj=document.getElementById('DSYMACode')
	if(obj) var DSYMCode=obj.value;
	if(DSYMCode==""){
		alert(t['code']) 
		return;
	}
	//检查症状代码是否唯一
	var obj=document.getElementById('Rep')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,DSYMCode)
	if(repflag=="Y")
	{
		alert(t['codeunique'])
		return;
	}
	var obj=document.getElementById('DSYMADesc')
	if(obj) var DSYMDesc=obj.value;
	if(DSYMDesc=="")
	{
		alert(t['desc']) 
		return;
	}
	var obj=document.getElementById('DSYMACTLOCDR')
	if(obj) var DSYMACTLOCDR=obj.value;
	//if(DSYMACTLOCDR=="")
	//	{
	//		alert(t['ctloc'])
	//		
	//		return;
	//	}
	var obj=document.getElementById('DSYMADateFrom')
	if(obj) var DSYMDateFrom=obj.value;
	if(DSYMDateFrom=="")
	{
		alert(t['startdate']) 
		return;
	}
	var obj=document.getElementById('DSYMADateTo')
	if(obj) var DSYMDateTo=obj.value;
	/*if(DSYMDateTo==""){
			alert(t['enddate']) 
			return;
	}*/
	var obj=document.getElementById('DSYMAActiveInActive')
	if(obj.options[0].selected){var DSYMActiveInActive=obj.options[0].value;}
	else {var DSYMActiveInActive=obj.options[1].value;}
	var obj=document.getElementById('ctloc')
	if(obj) var LocID=obj.value; 
	//通过隐藏元素addSignSymptom调用后台方法
	var obj=document.getElementById('addSignSymptom')
	if(obj) var encmeth=obj.value;
	//alert(DSYMCode+"^"+DSYMDesc+"^"+LocID+"^"+DSYMDateFrom+"^"+DSYMDateTo+"^"+DSYMActiveInActive)
	if (cspRunServerMethod(encmeth,DSYMCode,DSYMDesc,LocID,DSYMDateFrom,DSYMDateTo,DSYMActiveInActive)!='0'){
		alert(t['addfail']);
		return;
	}	
	try {	
		find_click();
	} catch(e) {};
}
//症状信息更新
function update_click()
{
	var obj=document.getElementById('DSYMARowId')
	if(obj) var DSYMRowId=obj.value;
	if(DSYMRowId==""){
			alert(t['selectwarn']) 
			return;
	}
	var obj=document.getElementById('DSYMACode')
	if(obj) {
		var DSYMCode=obj.value;
	}
	if(DSYMCode==""){
			alert(t['code']) 
			return;
		}
	var obj=document.getElementById('CodeUnquie');
	if(obj) {
		var Code=obj.value;
	}
	if(Code!=DSYMCode){
		alert(t['updatecodewarn']) 
		return;
	}
	var obj=document.getElementById('DSYMADesc')
	if(obj) var DSYMDesc=obj.value;
	if(DSYMDesc==""){
		alert(t['desc']) 
		return;
	}
	var obj=document.getElementById('DSYMACTLOCDR')
	if(obj) var DSYMACTLOCDR=obj.value;
	//if(DSYMACTLOCDR==""){
	//		alert(t['ctloc']) 
	//		return;
	//	}
	var obj=document.getElementById('DSYMADateFrom')
	if(obj) {
		var DSYMDateFrom=obj.value;
	}
	if(DSYMDateFrom==""){
		alert(t['startdate']) 
		return;
	}
	var obj=document.getElementById('DSYMADateTo')
	if(obj){
		var DSYMDateTo=obj.value;
	}
	/*if(DSYMDateTo==""){
		alert(t['enddate']) 
		return;
	}*/
	var obj=document.getElementById('DSYMAActiveInActive')
	if(obj) {var DSYMActiveInActive=obj.value;}
	if(DSYMActiveInActive==""){ 
		alert(t['active'])
		obj.options[0].selected=true;
		DSYMActiveInActive=obj.options[0].value;
	}
	var obj=document.getElementById('ctloc')
	if(obj) {var LocID=obj.value;}
	var obj=document.getElementById('updateSignSymptom')
	if(obj) {
		var encmeth=obj.value;
		if (cspRunServerMethod(encmeth,DSYMRowId,DSYMCode,DSYMDesc,LocID,DSYMDateFrom,DSYMDateTo,DSYMActiveInActive)!='0'){
				alert(t['updfail']);
				return;
		}
		else try {
				find_click();
		} catch(e) {};
	}
}
//症状信息删除
function del_click()
{
	var DSYMRowId=""
	var obj=document.getElementById('DSYMARowId')
	if(obj) DSYMRowId=obj.value;
	if(DSYMRowId==""){
	  alert(t['selectwarn']) 
	  return;
	}
	var obj=document.getElementById('delSignSymptom')
	if(obj){
		var encmeth=obj.value;
		if (cspRunServerMethod(encmeth,DSYMRowId)!='0'){
			alert(t['delfail']);
			return;
		}	
		try {	
			alert(t['delsuccess']);
			find_click();
		} catch(e) {
		};
	}
}    


//用于处理科室放大镜查询的函数
function getloctest(valu)
{
	var loc=valu.split("^");
	var obj=document.getElementById("ctloc")
	obj.value=loc[1];
}
function LocChangeHandle(){
	var obj=document.getElementById('DSYMACTLOCDR')
	if (obj){
		if (obj.value==""){
			var obj=document.getElementById("ctloc")
			obj.value="";
		}
	}
}
document.body.onload=DocumentLoadHandler;





