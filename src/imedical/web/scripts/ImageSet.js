var CONST_HOSPID=""; 
/*whc 2020-07-08 解决不能输入^问题*/
if(websys_isIE==true){
    document.onkeypress = null;
}else{
	document.removeEventListener("keydown", websys_sckey)
}
document.onkeydown = null;
/*end*/
function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	CONST_HOSPID=getHospID();
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=ImageSet&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}  
// var ClubName=document.getElementById("ClubName").value
var SelectedRow = 0;
//用于选择后更新的全局变量
var updateId=0
//用于选择删除的全局变量
var deleteCode=""
function BodyLoadHandler()
{
	var objSave=document.getElementById("Save")
    if (objSave) { objSave.onclick=SaveClick}
    
    var objDelete=document.getElementById("Delete")
    if(objDelete){objDelete.onclick=DeleteClick}
    
    var objSearch=document.getElementById("Search")
    if(objSearch){objSearch.onclick=SearchClick}
}
//点击选择一行
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tImageSet');//加载组件名: t+组件名
	
	var rows=objtbl.rows.length; 
	var RowObj=getRow(eSrc); 	// 选择时行的颜色//RowObj.className="Needless";
	var selectrow=RowObj.rowIndex;
	var objIcoDesc=document.getElementById('IcoDesc');
	var objIcoCode=document.getElementById('IcoCode');
	var objArcimCodeS=document.getElementById('ArcimCodeS');
	var objArcimColorCode=document.getElementById('ColorCode');
	
	var IcoDescTab=document.getElementById("IcoDescTabz"+selectrow);
	var IcoCodeTab=document.getElementById("IcoCodeTabz"+selectrow);
	var ColorCodeTab="";//document.getElementById("ColorCodez"+selectrow);
   	var ArcimCodeStrTab=document.getElementById("ArcimCodeStrTabz"+selectrow);



    if((SelectedRow==selectrow)&&(objIcoDesc.value!='')){
	    console.log(objIcoDesc.value);
		objIcoDesc.value = '';
		objIcoCode.value = '';
		objArcimCodeS.value = '';
		objArcimColorCode.value = '';
	}else{
		objIcoDesc.value=IcoDescTab.innerText;
		objIcoCode.value=IcoCodeTab.innerText;
		objArcimCodeS.value=ArcimCodeStrTab.innerText;
		//objArcimColorCode.value=ColorCodeTab.innerText;
		console.log(objIcoDesc.value);
	}
	SelectedRow = selectrow;
   	deleteCode=IcoCodeTab.innerText;
   	return;
}
//调用表中的保存函数保存数据函数
function SaveClick()
{
	 var IcoDesc=document.getElementById("IcoDesc").value
	 var IcoCode=document.getElementById("IcoCode").value	 
	 var ArcimCodeS=document.getElementById("ArcimCodeS").value	  
	 var ColorCode="";//document.getElementById("ColorCode").value	
    if(!IcoDesc||!IcoCode||!ArcimCodeS){alert("填写的信息存在空值,请检查!");return}
    //if(ColorCode.length!=0&&(ColorCode.length<7||ColorCode.indexOf('#')<0)){alert("颜色代码格式有问题,请检查!");return}
	 var SaveImageSet=document.getElementById("SaveImageSet").value;
	//alert(IcoDesc+"^"+IcoCode+"^"+ArcimCodeS)
	//把数据保存到表中
	CONST_HOSPID=getHospID();
	var str=cspRunServerMethod(SaveImageSet,IcoDesc,IcoCode,ArcimCodeS,ColorCode,CONST_HOSPID)
	alert("保存成功")
	//重新加载函数？？？刷新函数——只刷新当前页面
     location.reload()	
}

function DeleteClick() {
	var IcoDesc = document.getElementById("IcoDesc").value
		var ret = confirm("确定删除?");
	if (ret) {
		if (!IcoDesc) {
			alert("请选择删除的行");
			return
		}
		if (deleteCode == "") {
			alert("这是通过点击行，进行删除，暂时不能其他删除");
			return
		}
		var DeleteImageSet = document.getElementById("DeleteImageSet").value;
		//alert(deleteCode);
		var str = cspRunServerMethod(DeleteImageSet, deleteCode)
			alert("删除成功")
			//重新加载函数？？？刷新函数——只刷新当前页面
			location.reload()
	}
	else{
		return;
	}
}
//以俱乐部名称作为条件查询，存在问题——刷新时候还保留上一次的参数
function SearchClick()
{
	 var ClubName=document.getElementById("ClubName").value
	 var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCClubHealth"+"&clubName1="+ClubName;
     location.href=lnk;
   // document.getElementById("ClubName").value=ClubName
   // alert(ClubName)
     //location.reload()	
}
document.body.onload = BodyLoadHandler;

	 
