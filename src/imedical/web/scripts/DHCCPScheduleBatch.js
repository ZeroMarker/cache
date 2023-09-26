//DHCCPScheduleBatch
function BodyLoadHandler() {
	var obj=document.getElementById('LocList');
	if (obj) obj.ondblclick = LocList_DblClick;
	var obj=document.getElementById('Create');
	if (obj) obj.onclick = Create_Click;
	/*
	var obj=document.getElementById('depname');
	if (obj) obj.onkeyup = depname_KeyUp;
	var obj=document.getElementById('markname');
	if (obj) obj.onkeyup = markname_KeyUp;
	*/
	var obj=document.getElementById("AddLoc")
	if(obj){
		obj.onclick=AddLocClick;	
	}
	var obj=document.getElementById("AddDoc")
	if(obj){
		obj.onclick=AddDocClick;	
	}
	var obj=document.getElementById("ScheduleList")
	if(obj){
		obj.ondblclick = ScheduleListDblClick;	
	}
	var obj=document.getElementById("ClearScheduleList")
	if(obj){
		obj.onclick=ClearScheduleListClick;	
	}
	var obj=document.getElementById("AllDep")
	if(obj){
		obj.onclick = AllDepClick;	
	}
	
	
	defineStartDate();
}
// guorongyong by 2008-03-31 默认开始日期为上次生成的日期
function defineStartDate()
{
	    //var document.getElementById('StartDateEncrypt');
	    var tkClass='web.DHCOPRegTime';
		var tkMethod='GetdefineStartDate';
		var defineStartDate=tkMakeServerCall(tkClass,tkMethod);
		var StartDateObj=document.getElementById('StartDate');
		StartDateObj.value=defineStartDate;
}
function AllDepClick(){
	var DeptStrObj=document.getElementById("DeptStr")
		if(DeptStrObj){
			ShowLocList(DeptStrObj.value)	
		}	
}
function AddItemToLocList(LocStr)	{
	//var LocStr=tkMakeServerCall('web.DHCCPSchedBatch','SendBatchLocMsg');
	var LocList=document.getElementById('LocList');
	LocList.length=0
	var arytxt=new Array();
	var aryval=new Array();
	var arystr=LocStr.split("\001");
	if (arystr.length>0) {
		j=0
		for (var i=0;i<arystr.length;i++) {
			var arytmp=arystr[i].split("^");
			arytxt[j]=arytmp[1]
			aryval[j]=arytmp[0];
			j++
		}	
	}
	AddItemToList(LocList,arytxt,aryval);
}
function ShowLocList(LocStr)	{
	//var LocStr=tkMakeServerCall('web.DHCCPSchedBatch','SendBatchLocMsg');
	var LocList=document.getElementById('LocList');
	var arytxt=new Array();
	var aryval=new Array();
	var arystr=LocStr.split("^");
	ClearAllList(LocList)
	if (arystr.length>0) {
		j=0
		for (var i=0;i<arystr.length;i++) {
			var arytmp=arystr[i].split(",");
			arytxt[j]=arytmp[1]
			aryval[j]=arytmp[0];
			j++
		}	
	}
	AddItemToList(LocList,arytxt,aryval);
}
function AddItemToList(obj,arytxt,aryval) {
	if (arytxt.length>0) {
		if (arytxt[0]!="") {
			var lstlen=obj.length;
			for (var i=0;i<arytxt.length;i++) {
				
				obj.options[lstlen] = new Option(arytxt[i],aryval[i]); lstlen++;}
		}
	}
}
function LocList_DblClick()	{
	var DocList=document.getElementById('DoctorList');
	DocList.length=0
	var LocList=document.getElementById('LocList');
	var SelItem=LocList.options[LocList.selectedIndex];
	var Loc=SelItem.value;
	var LocDescObj=document.getElementById("LocDesc")
	if(LocDescObj){
		LocDescObj.value=SelItem.text;
	}
	var FindDocObj=document.getElementById("FindDoc")
	var FindDocFlag=""
	if(FindDocObj){
		FindDocFlag	=FindDocObj.checked
	}
	if (SelItem) {
		if(!FindDocFlag){
			//alert(SelItem.value+"^"+SelItem.text)
			ClearAllList(DocList);
			var DocStr=tkMakeServerCall('web.DHCCPSchedBatch','SendBatchDocMsg',Loc);
			var arytxt=new Array();
			var aryval=new Array();
			var arystr=DocStr.split("\001");
			if (arystr.length>0) {
				j=0
				for (var i=0;i<arystr.length;i++) {
					var arytmp=arystr[i].split("^");
					arytxt[j]=arytmp[1]
					aryval[j]=arytmp[0];
					j++
				}	
			}
			AddItemToList(DocList,arytxt,aryval);
		}else{
			ClearAllList(DocList);
			var DocStr=tkMakeServerCall('web.DHCCPSchedBatch','GetDocList',Loc);
			var arytxt=new Array();
			var aryval=new Array();
			var arystr=DocStr.split("^");
			if (arystr.length>0) {
				j=0
				for (var i=0;i<arystr.length;i++) {
					var arytmp=arystr[i].split(",");
					arytxt[j]=arytmp[1]
					aryval[j]=arytmp[0];
					j++
				}	
			}
			AddItemToList(DocList,arytxt,aryval);

		}
	}
}
/*function confirm(str) { 
	execScript("n = msgbox('"+str+"', 257)", "vbscript"); 
	return(n == 1); 
} */
//计算两个日期天数差的函数，通用
function DateDiff(sDate1, sDate2) {  //sDate1和sDate2是yyyy-MM-dd格式
    var aDate, oDate1, oDate2, iDays;
    if (websys_DateFormat=="Y-m-d"){
	    aDate = sDate1.split("-");
    	oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("-");
    	oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
	}else{
		aDate = sDate1.split("/"); // 12/02/2018
    	oDate1 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
    	aDate = sDate2.split("/");
    	oDate2 = new Date(aDate[2] + '-' + aDate[1] + '-' + aDate[0]);
	}
    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
    return iDays;  //返回相差天数
}
function Create_Click()	{
	var StartDateObj=document.getElementById('StartDate');
	var EndDateObj=document.getElementById('EndDate');
	if((StartDateObj.value=="")||(EndDateObj.value==""))
	{
		alert('请输入开始时间和结束时间!');
		return;
	}
	var schstr=""
	var ScheduleListObj=document.getElementById("ScheduleList")
	if(ScheduleListObj){
		for(var i=0;i<ScheduleListObj.length;i++){
			var opt=ScheduleListObj.options[i]
			if(schstr==""){
				schstr=opt.value	
			}else{
				schstr=schstr+"^"+opt.value	
			}
		}	
	}
	if (!CompareDate(StartDateObj.value,EndDateObj.value)){alert("请输入有效的时间");return;}
	var DateFiffDays=DateDiff(StartDateObj.value,EndDateObj.value);
	if (parseInt(DateFiffDays)>180){
		var Conf=confirm('生成的排班记录超过180天,是否继续?')
		if (!Conf) {return false;}
	}
	var Conf=confirm('是否要生成全部排班记录?')
	if (Conf) {
		var StartDate=document.getElementById('StartDate');
		if (StartDate)	{var DateF=StartDate.value}
		var EndDate=document.getElementById('EndDate');
		if (EndDate)	{var DateT=EndDate.value}
		var Mode=DHCC_GetElementData('Mode');
		if (Mode.checked==true)	{var MD=1} else {var MD=0}
		/*
		var DepID="",MarkID="";
		var obj=document.getElementById('depid');
		if (obj){DepID=obj.value;}
		var obj=document.getElementById('markid');
		if (obj){MarkID=obj.value;}
		*/
		var tkClass='web.DHCCPSchedBatch';
		var tkMethod='GeneSched'
		var DocStr=tkMakeServerCall(tkClass,tkMethod,DateF,DateT,MD,schstr);
		if (DocStr==""){
			alert("没有需要生成的排班记录.(没有维护排班记录或该医生已生成排班)")
		}else{
			if (DocStr.split("^")[0]=="-1"){
				alert(DocStr)
				return
			}
			
			AddItemToLocList(DocStr);
		}
		AddItemToLocList(DocStr);
	}
	
}
function Mode_Click()	{
	var ModeObj=document.getElementById('Mode');
}
function ClearAllList(obj) {
	if (obj.options.length>0) {
	for (var i=obj.options.length-1; i>=0; i--) obj.options[i] = null;
	}
}
function AddLocClick(){

	var obj=document.getElementById("LocList")


	var ScheObj=document.getElementById("ScheduleList")
	if(obj){
		for(var i=0;i<obj.options.length;i++){
			var optObj=obj.options[i];
			if(optObj.selected){
				ScheObj.options[ScheObj.options.length]=new Option(optObj.text,optObj.value)
			}
				
		}
		
			


	}
}
function AddDocClick(){
	var obj=document.getElementById("DoctorList")
	var ScheObj=document.getElementById("ScheduleList")

	var LocDesc=document.getElementById("LocDesc").value
	if(obj){
		for(var i=0;i<obj.options.length;i++){
			var optObj=obj.options[i];
			if(optObj.selected){
				ScheObj.options[ScheObj.options.length]=new Option(LocDesc+"|"+optObj.text,optObj.value)
			}	
		}	
	}	



}
function ScheduleListDblClick(){


	var SchListObj=document.getElementById("ScheduleList")
	if(SchListObj){
		if(SchListObj.selectedIndex>=0){
			SchListObj.options.remove(SchListObj.selectedIndex)	
		}	



	}	
}
function ClearScheduleListClick() {
	var SchListObj=document.getElementById("ScheduleList")
	if (SchListObj) SchListObj.length=0;
}
/*
function deplook(str) {
	if (str!=""){
	var obj=document.getElementById('depid');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('markname');
	if (obj){obj.value=""}
	var obj=document.getElementById('markid');
	if (obj){obj.value=""}
	}
}
function marklook(str) {
	if (str!=""){
		var obj=document.getElementById('markid');
		var tem=str.split("^");
		obj.value=tem[1];
	}
}
function depname_KeyUp(e)
{
	var obj=document.getElementById('depname');
	if (obj.value==""){
		var obj=document.getElementById('depid');
		if (obj){obj.value=""}
	}	
}
function markname_KeyUp(e)
{
	var obj=document.getElementById('markname');
	if (obj.value==""){
		var obj=document.getElementById('markid');
		if (obj){obj.value=""}
	}
}
*/


document.body.onload = BodyLoadHandler;
