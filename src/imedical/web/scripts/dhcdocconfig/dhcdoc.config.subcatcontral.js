var arrayObj = new Array(
      new Array("List_FrequencedItemCat","FrequencedItemCat"),
      new Array("List_NeedExecCat","NeedExecCat"),
      new Array("List_NotAlertRepeatItemCat","NotAlertRepeatItemCat"),
      new Array("List_OPUnRepeatItemCat","OPUnRepeatItemCat"),
      new Array("List_NoDisplayItemCat","NoDisplayItemCat"), 
      new Array("List_CheckItemCat","CheckItemCat"),
      new Array("List_MedItemCat","MedItemCat"),
      new Array("List_CPMedItemCat","CPMedItemCat"),
      new Array("List_LimitMedItemCat","LimitMedItemCat"),
      new Array("List_PreciousDrugItemCat","PreciousDrugItemCat"),	
      new Array("List_AllowEntryDecimalItemCat","AllowEntryDecimalItemCat"), 
      new Array("List_NotAlertZeroItemCat","NotAlertZeroItemCat"),	  
      new Array("List_StopAllExecItemCat","StopAllExecItemCat"),
	  new Array("List_TreatItemCat","TreatItemCat"),
	  new Array("List_SelectInstrNotDrugCat","SelectInstrNotDrugCat"),
	  new Array("List_IssuedNotCancelItemCat","IssuedNotCancelItemCat"),	 
	  new Array("List_IPNecessaryCat","IPNecessaryCat"),
	  new Array("List_NotSamePriorNeedAlertItemCat","NotSamePriorNeedAlertItemCat"),
	  new Array("List_NotLinkItemCat","NotLinkItemCat"),
	  new Array("List_OPAutoDurCat","OPAutoDurCat"),
	  new Array("List_AfterNurDealCanUnuseItemCat","AfterNurDealCanUnuseItemCat")
);
var arrayObj1=new Array(
      new Array("Combo_FrequencedItemFreq","FrequencedItemFreq"),
      new Array("Combo_NeedExecFreq","NeedExecFreq")
);
var arrayObj2=new Array(
      new Array("Combo_FrequencedItemDur","FrequencedItemDur"),
      new Array("Combo_NeedExecDur","NeedExecDur")
);
$(function(){  
	InitHospList();
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_SubCatContral");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
	$('#Confirm').click(SaveSubCatContral);
}
function Init(){
   for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   LoadFreqData(param1,param2);
   }
   for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   LoadDurData(param1,param2);
   }
   for( var i=0;i<arrayObj.length;i++) {
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
       LoadData(param1,param2);	    
   }
   //初始化分类
	InitComboCategory()
	$("#List_ReSetOrdSubCat").empty();
	LoadSubData("List_ReSetOrdSubCat","")
    var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var PropmtInfo=tkMakeServerCall("DHCDoc.DHCDocConfig.SubCatContral","GetPropmtInfo",HospID);
	$("#Prompt").html(PropmtInfo)
}
function LoadSubData(param1,param2){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatListNew",
		value:param2,
		HospId:HospID,
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function InitComboCategory()
{
	$("#Combo_Category").combobox({  
    	valueField:'Rowid',   
    	textField:'Desc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'ReOrdSubCatList';
			param.ArgCnt =0;
		},
		onChange:function (catdr,o){
			$("#List_ReSetOrdSubCat").empty();
			LoadSubData("List_ReSetOrdSubCat",catdr)
		}
	});
}
function LoadData(param1,param2){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({ 
		ClassName:"DHCDoc.DHCDocConfig.SubCatContral", 
		QueryName:"FindCatList",
		value:param2,
		HospId:HospID,
		rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#"+param1+"").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
}
function LoadDurData(item,param2)
{
	$("#"+item+"").combobox({
		valueField:'DurRowId',   
    	textField:'DurCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList&value="+param2+"&Type=XY&HospId="+$HUI.combogrid('#_HospList').getValue(),
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}
function LoadFreqData(item,param2)
{
	$("#"+item+"").combobox({
		valueField:'FreqRowId',   
    	textField:'FreqCode',
    	url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindFreqList&value="+param2+"&Type=&HospId="+$HUI.combogrid('#_HospList').getValue(),
    	loadFilter: function(data){
			return data['rows'];
		}
	});
}

function SaveSubCatContral()
{
	var HospId=$HUI.combogrid('#_HospList').getValue();
	var DataList=""
	for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
	   var FrequencedItemFreq=$("#"+param1+"").combobox('getValue');
	   if (!FrequencedItemFreq) FrequencedItemFreq="";
	   DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+FrequencedItemFreq
   }
   for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
	   var DurationItemDur=$("#"+param1+"").combobox('getValue');
	   if (!DurationItemDur) DurationItemDur="";
	   DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+DurationItemDur
   }
   for( var i=0;i<arrayObj.length;i++) {
	   var CatIDStr=""
	   var param1=arrayObj[i][0];
	   var param2=arrayObj[i][1];
	   var size = $("#" + param1 + " option").size();
	   if(size>0){
			$.each($("#"+param1+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue
			  else CatIDStr=CatIDStr+"^"+svalue
			})
			DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CatIDStr
	   }	   
   }
   var ComboValue=$("#Combo_Category").combobox('getValue');
   if(ComboValue!=""){
		var CatIDStr=""
		var size = $("#List_ReSetOrdSubCat"  + " option").size();
		if(size>0){
			$.each($("#List_ReSetOrdSubCat"+" option:selected"), function(i,own){
	            var svalue = $(own).val();
				if (CatIDStr=="") CatIDStr=svalue
				else CatIDStr=CatIDStr+"^"+svalue
			})
		}
		var objScope=$.m({ 
			ClassName:"web.DHCDocConfig", 
			MethodName:"SaveConfig1",
			Node:"DHCDocReSetOrdSubCat",
			Node1:ComboValue,
			NodeValue:CatIDStr,
			HospId:HospId
		},false);
    }
    var value=$.m({ 
		ClassName:"web.DHCDocConfig", 
		MethodName:"SaveConfig",
		Coninfo:DataList,
		HospId:HospId
	},false);
	if(value=="0"){
		$.messager.show({title:"提示",msg:"保存成功"});					
	}
	if (ComboValue!=""){
		$("#List_ReSetOrdSubCat").empty();
		LoadSubData("List_ReSetOrdSubCat",ComboValue);
	}
}
