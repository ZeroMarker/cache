function ALGDescCTSelectHandler(str){
	var lu=str.split("^");
	var obj=document.getElementById("AllergenRowId");
	if (obj) obj.value=lu[5];
	var obj=document.getElementById("TagCode");
	if (obj) obj.value=lu[4];
	var obj=document.getElementById("ALGItem");
	if (obj) obj.value="";
	var obj=document.getElementById("ALGItemRowId");
	if (obj) obj.value="";			
}

function CategoryLookup(str) {
	/*
	try {
		CustomCategoryLookup();
	} catch(e) { }
	finally {
	*/
		var lu=str.split("^");
		var obj=document.getElementById("CategoryRowId");
		if (obj) obj.value=lu[3];
		var obj=document.getElementById("TagCode");
		if (obj) obj.value=lu[2];
		var obj=document.getElementById("ALGDescCT");
		if (obj) obj.value="";
		var obj=document.getElementById("AllergenRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItem");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItemRowId");
		if (obj) obj.value="";	
	//}
}
function TagLookup(str) {
	var lu=str.split("^");
	var obj=document.getElementById("TagCode");
	if (obj) obj.value=lu[1];
	var obj=document.getElementById("CategoryRowId");
	if (obj) obj.value="";
	var obj=document.getElementById("ALGDescCT");
	if (obj) obj.value="";
	var obj=document.getElementById("AllergenRowId"); 
	if (obj) obj.value="";
	var obj=document.getElementById("ALGItem");
	if (obj) obj.value="";
	var obj=document.getElementById("ALGItemRowId");
	if (obj) obj.value="";	
	
}
function ALGItemSelect(str)
{
	var lu=str.split("^");	
	var obj=document.getElementById("ALGItemRowId");
	if (obj) obj.value=lu[1];
	var ALGItemRowId=lu[1];
	var CategoryRowId=document.getElementById("CategoryRowId").value;
	var TagCode=document.getElementById("TagCode").value;
	var str=tkMakeServerCall('web.DHCPAAllergy','GetALGStr',ALGItemRowId,CategoryRowId,TagCode)
	if(str!=""){
		var lu=str.split("^");
		var obj=document.getElementById("AllergenRowId");
		if (obj) obj.value=lu[5];
		var obj=document.getElementById("TagCode");
		if (obj) obj.value=lu[4];
		var obj=document.getElementById("ALGDescCT");
		if (obj) obj.value=lu[0];
	}
}
function BodyLoadHandler() {
	//过敏分类
	var obj=document.getElementById("ALGMRCCat");
	if (obj) obj.onchange = ALGMRCCatChangeHandler;
	//过敏源
	var obj=document.getElementById("ALGDescCT");
	if (obj) obj.onchange = ALGDescCTChangeHandler;
	//过敏类型
	var obj=document.getElementById("MRCATTagDescription");
	if (obj) obj.onchange = MRCATTagDescriptionChangeHandler;
	var obj=document.getElementById("Update");
	if (obj) obj.onclick=UpdateOnClick;
	var obj=document.getElementById("Delete");
	if (obj) obj.onclick=DeleteOnClick;
}
function ALGMRCCatChangeHandler()
{
	var obj=document.getElementById("ALGMRCCat");
	if ((obj)&&(obj.value==""))
	{
		var obj=document.getElementById("CategoryRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("TagCode");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGDescCT");
		if (obj) obj.value="";
		var obj=document.getElementById("AllergenRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItem");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItemRowId");
		if (obj) obj.value="";	
	}
}
function ALGDescCTChangeHandler()
{
	var obj=document.getElementById("ALGDescCT");
	if ((obj)&&(obj.value==""))
	{
		var obj=document.getElementById("AllergenRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItem");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItemRowId");
		if (obj) obj.value="";	
	}
}
function MRCATTagDescriptionChangeHandler()
{
	var obj=document.getElementById("MRCATTagDescription");
	if ((obj)&&(obj.value==""))
	{
		var obj=document.getElementById("ALGMRCCat");
		if (obj) obj.value="";
		var obj=document.getElementById("CategoryRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("TagCode");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGDescCT");
		if (obj) obj.value="";
		var obj=document.getElementById("AllergenRowId");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItem");
		if (obj) obj.value="";
		var obj=document.getElementById("ALGItemRowId");
		if (obj) obj.value="";	
	}
}
function UpdateOnClick()
{
	var obj=document.getElementById("ALGOnsetDate");
	if (obj){
		if (obj.value==""){alert("请选择过敏日期");return}
		if (websys_DateFormat=='Y-m-d'){
			var sd=(obj.value).split("-");
			var IDateCompare = new Date(sd[0],sd[1]-1,sd[2]);
		}else{
			var sd=(obj.value).split("/");
			var IDateCompare = new Date(sd[2],sd[1]-1,sd[0]);
		}
		
        var TodayDate=new Date()
		if (IDateCompare>TodayDate){
	           alert("过敏日期不能大于当天,请重新选择!"); return; 
	    }
	}
	var AllergenRowId="",ALGItemRowId="";
	var obj=document.getElementById("AllergenRowId");
	if (obj)AllergenRowId=obj.value;
	var obj=document.getElementById("ALGItemRowId");
	if (obj)ALGItemRowId=obj.value;
	if ((AllergenRowId=="")&&(ALGItemRowId==""))
	{
		alert("过敏源和过敏项目必须至少填一项");
		return;
	}
	Update_click();
	window.opener.location.reload();
}
function DeleteOnClick()
{
	Delete_click();
	window.opener.location.reload();
}
document.body.onload = BodyLoadHandler;

