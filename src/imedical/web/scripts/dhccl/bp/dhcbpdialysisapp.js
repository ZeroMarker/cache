var PatientID = "";     /// 病人ID
var EpisodeID = "";     /// 病人就诊ID
var mradm = "";			/// 就诊诊断ID
var CsType = "";        /// 会诊类型
var LocID = "";     /// 科室
var selDialysisAppId="" //
var IsCheckFlag=false;//是否选中的标志
var selRowIndex;//保存当前选中行
var LgGroup = session['LOGON.GROUPDESC'];
//var getDate=new Date();
//var resDate=format(getDate,'dd/MM/yyyy');

var changeAnticoagulantList=[];
var anticoagulantStr="",ifAntValue=0;
var selJsonData= new Array();
var locId=197;
/// 页面初始化函数
function initPageDefault(){

	InitPatEpisodeID();       /// 初始化加载病人就诊ID
	InitFormItem();
	GetPatBaseInfo();         /// 病人就诊信息
	
	 if(typeof HISUIStyleCode=='string' && HISUIStyleCode=='lite'){
		
				$("#PatBase").css({
					'background-color':'#f5f5f5'
				})
				
				$("#centerContainer").css({
                   'border':'1px solid #e2e2e2'
                  
                   })
               $("#NorthCondicioner").css({
                   'border':'1px solid #e2e2e2',
                   'border-bottom-width':'0'
                   
                   })
                   /*
                 $("#noTitleList2").panel-body-noheader.panel-body.css({
	                 'border-color':'#ccc'
                 })
                 */
       }
       else
       {
            $("#NorthCondicioner").css({'border':'1px solid #CCC','border-bottom-width':'0'})
            $("#centerContainer").css({'border':'1px solid #CCC'})
       }
}

/// 初始化加载病人就诊ID
function InitPatEpisodeID(){
	PatientID = dhccl.getUrlParam("PatientID");  /// 病人ID
	EpisodeID = dhccl.getUrlParam("EpisodeID");  /// 就诊ID
	mradm = dhccl.getUrlParam("mradm");          /// 就诊诊断ID
	CsType = dhccl.getUrlParam("CsType");        /// 会诊类型
	LocID=session['LOGON.CTLOCID']; //当前科室
}

/// 病人就诊信息
function GetPatBaseInfo(){
	runClassMethod("web.DHCBPDialysisApp","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		//var jsonObject = JSON.parse(jsonString);
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			//alert(jsonObject[this.id]);
			if (this.id=="PatSex")
			{
				if (jsonObject.PatSex == "男"){
					$("#PatPhoto").attr("src","../scripts/dhcclinic/images/boy.png");
				}else if (jsonObject.PatSex == "女"){
					$("#PatPhoto").attr("src","../scripts/dhcclinic/images/girl.png");
				}else{
					$("#PatPhoto").attr("src","../scripts/dhcclinic/images/unman.png");
				}
			}
		})
	},'json',false)
}
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //当前combobox的值
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
		$(item).combobox("clear");	    
	    $(item).combobox("reload");
	    if ((val==undefined)&&(txt!=""))
	    {
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
///combogrid不是选择，多选下拉框提示
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //当前combobox的值
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //获取combobox所有数据
	var result = true;      //为true说明输入的值在下拉框数据中不存在
	for (var i = 0; i < allData.length; i++) {
		for (var j = 0; j < vals.length; j++) 
		{
			if (vals[j] == allData[i][idField]) {
	    		result = false;
	    		break;
	    	}
		}
	}
	if (result) {
	    if ((vals.length==0)&&(txt!=""))
	    {
		    $(item).combobox("clear");	    
	    	$(item).combobox("reload");
		    $(item).combobox('setValue',"");
	    	$.messager.alert("提示","请从下拉框选择","error");
	    	return;
	    }
	}
}
DateFormat=function(ConfigValue){
		var y = ConfigValue.substr(6,4);
		var m = ConfigValue.substr(0,2);
		var d = ConfigValue.substr(3,2);
		return y+'-'+m+'-'+d;
	}
function format(time, format) {
    var t = new Date(time);
    var tf = function (i) {
      return (i < 10 ? '0' : '') + i
    };
    return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function (a) {
      switch (a) {
        case 'yyyy':
          return tf(t.getFullYear());
          break;
        case 'MM':
          return tf(t.getMonth() + 1);
          break;
        case 'mm':
          return tf(t.getMinutes());
          break;
        case 'dd':
          return tf(t.getDate());
          break;
        case 'HH':
          return tf(t.getHours());
          break;
        case 'ss':
          return tf(t.getSeconds());
          break;
      }
    })
  }
function InitFormItem()
{
	//$("#AppDate").datebox('setValue',resDate);	
	$HUI.datebox("#AppDate",{
	})
	
    $HUI.combogrid("#InfectiousDiseaseInfo",{
		idField:"Code",
		textField:"Desc",
		mode:"remote",
		multiple:true,
		//panelHeight:'auto',
        data:[{'Code':"HBV",'Desc':"乙肝"}
        ,{'Code':"HCV",'Desc':"丙肝"}
        ,{'Code':"HIV",'Desc':"艾滋病"}
		,{'Code':"SP",'Desc':"梅毒"}
        ,{'Code':"Negative",'Desc':"阴性"}],  
        columns:[[
			{filed:"Code",checkbox:true,width:0},
			{field:"Desc",title:"全选",width:"100"}
		]],		
		onHidePanel: function () {
        	OnHidePanel3("#InfectiousDiseaseInfo");
        }     	
	});		
	$HUI.combobox("#DialysisStatus",{
		valueField:"Code",
		textField:'Desc',
		panelHeight:'auto',
        data:[{'Code':"G",'Desc':"诱导透析"}
        ,{'Code':"K",'Desc':"维持透析"}
        ,{'Code':"T",'Desc':"过渡期"}
		],  
		onHidePanel: function () {
        	OnHidePanel("#DialysisStatus");
        }
	 });
	 $HUI.combobox("#ArrangePlan",{
		valueField:"Code",
		textField:'Desc',
		panelHeight:'auto',
        data:[{'Code':"G3",'Desc':"诱导3次"}
        ,{'Code':"K3",'Desc':"维持3次1周"}
        ,{'Code':"T1",'Desc':"临时1次,之后按需"}
        ,{'Code':"T2",'Desc':"临时2次,之后按需"}
        ,{'Code':"T3",'Desc':"临时3次,之后按需"}
		],  
		onHidePanel: function () {
        	OnHidePanel("#ArrangePlan");
        }
	 })
	 $HUI.combobox("#VascularAccess",{
			url:$URL+"?ClassName=web.DHCBPCVascularAccess&QueryName=GetVascularAccessList&ResultSetType=array",
			textField:"Description",
			valueField:"Id",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onBeforeLoad:function(param)
        	{
            	param.locId=locId;
        	}
	})
	$HUI.combobox("#BodySite",{
			url:$URL+"?ClassName=web.DHCBPCVascularAccess&QueryName=FindCLCBodySite&ResultSetType=array",
			textField:"Description",
			valueField:"Id",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onBeforeLoad:function(param)
        	{
            	param.locId=locId;
        	}
	})
	$HUI.combobox("#AnticoagulantMode",{
			url:$URL+"?ClassName=web.DHCBPCAnticoagulantMode&QueryName=GetAnticoagulantModeList&ResultSetType=array",
			textField:"Description",
			valueField:"Id",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onChange:function(row){
				gradeChange(row);
			},
			onBeforeLoad:function(param)
        	{
            	param.locId=locId;
        	}, 					
	})
	/*
	$HUI.combobox("#AnticoagulantMode",{
			url:$URL+"?ClassName=web.DHCBPCAnticoagulantMode&QueryName=FindAntMode&ResultSetType=array",
			textField:"tBPCAMDesc",
			valueField:"tBPCAMRowId",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onChange:function(row){
				gradeChange(row);
			} 					
	})
	*/
	$HUI.combobox("#BPMode",{
			url:$URL+"?ClassName=web.DHCBPCBloodPurificationMode&QueryName=FindBloodPurifMode&ResultSetType=array",
			textField:"Description",
			valueField:"Id",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
        		OnHidePanel("#BPMode");
        	},
			onBeforeLoad:function(param)
        	{
            	param.locId=locId;
        	},
	})
	/*
	$HUI.combobox("#BPMode",{
			url:$URL+"?ClassName=web.DHCBPCBloodPurificationMode&QueryName=FindDHCBPCBPMode&ResultSetType=array",
			textField:"tBPCBPMDesc",
			valueField:"tBPCBPMRowId",
			panelHeight:'auto',
			formatter:function(row){
				
				var opts = $(this).combobox('options');
				return row[opts.textField];
			},
			onHidePanel: function () {
        		OnHidePanel("#BPMode");
        	}
	})*/
	//抗凝选择药品
	$HUI.combobox("#selectDrug1",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        onHidePanel: function () {
        	OnHidePanel("#selectDrug1");
        }
    })
    //抗凝选择药品
	$HUI.combobox("#selectDrug2",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        onHidePanel: function () {
        	OnHidePanel("#selectDrug2");
        }
    })
}

//初始化患者列表
function initPatientsList(){    
	var locId=session['LOGON.CTLOCID'];
    $("#loc").next(".combo").find(".combo-text").prop("placeholder", "科室");
    //$("#patientWard").next(".combo").find(".combo-text").prop("placeholder", "病区");	
}
//选中列表行数据带入录入框
function setSelectData(rowData){
	$("#DialysisStatus").combobox('setValue',rowData.dialysisStatus);
	var infectiousCode=[]
	infectiousCode=rowData.infectiousCode.split(",");	
	$("#InfectiousDiseaseInfo").combogrid('setValues',infectiousCode);
	$("#ArrangePlan").combobox('setValue',rowData.arrangePlan);
	$("#AppDate").datebox('setValue',rowData.appDate);	
	$("#VascularAccess").combobox('setValue',rowData.vascularAccess);
	$("#BodySite").combobox('setValue',rowData.bodySite);	
	$("#AnticoagulantMode").combobox('setValue',rowData.anticoagulantMode);
	//$("#AnticoagulantMode").combobox('setText',rowData.anticoagulantModeDesc);
	$("#AnticoagulantDrug").val(rowData.anticoagulantDrug);	
	$("#BPMode").combobox('setValue',rowData.bpMode);
	$("#PlanTherapyDuration").val(rowData.planTherapyDuration);
	$("#BFR").val(rowData.bpBFR);
	$("#DewaterAmount").val(rowData.dewaterAmount);	
	$("#K").val(rowData.bpK);
	$("#Ca2").val(rowData.bpCa2);
	$("#Na").val(rowData.bpNa);
	$("#Note").val(rowData.bpNote);
	$("#PhoneNum").val(rowData.bpPhoneNum);
}
//取消选中列表时清空录入框
function clearControlValue(){
	$("#DialysisStatus").combobox('setValue',"");
	$("#InfectiousDiseaseInfo").combogrid('setValue',"");
	$("#ArrangePlan").combobox('setValue',"");
	$("#AppDate").datebox('setValue',"");
	$("#VascularAccess").combobox('setValue',"");
	$("#BodySite").combobox('setValue',"");
	$("#AnticoagulantMode").combobox('setValue',"");
	$("#AnticoagulantDrug").val("");
	$("#BPMode").combobox('setValue',"");
	$("#PlanTherapyDuration").val("");
	$("#BFR").val("");
	$("#DewaterAmount").val("");
	$("#K").val("");
	$("#Ca2").val("");
	$("#Na").val("");
	$("#Note").val("");
	$("#PhoneNum").val("");
}

//去掉重复项目
function newArrFunc(arr){
	var newArr = [];
	for(var i=0;i<arr.length;i++){
		var val=arr[i]
		if($.inArray(val,newArr) == -1){
			newArr.push(arr[i]);
		}
	}
	return newArr;
}
//添加显示的项目
function dispalyChild(jsonData) {
	var catValArr = new Array()
	selJsonData.length=0;
	//循环获取全部对象的分类id
	for (var i = 0; i < jsonData.length; i++) {
		var item = jsonData[i];
		var catNum=item.Cat;
		if (catNum>0) 
		{
			catValArr.push(catNum)
		}
	}
	//去掉重复的分类id
	catValArr=newArrFunc(catValArr);
	//筛选出满足条件的药品项目
	for (i=0;i<catValArr.length;i++)
	{
		for (var j = 0; j < jsonData.length; j++) {
			var item = jsonData[j];
			var catNum=item.Cat;
			if (catValArr[i]==catNum)
			{
				selJsonData.push(item)
			}			
		}
	}
	dispalyDialog(selJsonData);
}
//显示药品选择窗体
function dispalyDialog(selJsonData)
{
	var fieldset = document.getElementById("fieldset");
	fieldset.setAttribute("style","display:none;");	
	var catId="";
	var drugData,drugData2;
	drugData = [], drugData2=[] ;
	for (var i = 0; i < selJsonData.length; i++) {
		var item = selJsonData[i];
		var cat=item.Cat;
		var code=item.Code;
		var desc=item.Desc;		
		if (catId=="") catId=cat
		if (catId==cat) 
		{
			drugData.push({Code:code,Desc:desc});
		}
		else
		{
			drugData2.push({Code:code,Desc:desc});
		}
	}
	$("#selectDrug1").combobox("loadData", "")
	$("#selectDrug1").combobox({disabled: true});
	$("#selectDrug2").combobox({disabled: true});  
	$("#selectDrug2").combobox("loadData", "")
	if (drugData.length>1)
	{
		$("#selectDrug1").combobox({disabled: false});
		$("#selectDrug1").combobox("loadData", drugData);		
	}	
	if (drugData2.length>1)
	{
		$("#selectDrug2").combobox({disabled: false});
		$("#selectDrug2").combobox("loadData", drugData2);
	}
	if ((drugData.length<=1)&&(drugData2.length<=1)) return;
	var selectAntCodeArr=new Array();
	var jsonData=[];
	$("#BPCDrugDlg").show();
		var BPCDrugDlgObj=$HUI.dialog("#BPCDrugDlg",{
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			title:'相关药品选择',
			buttons:[{
				text:"保存",
				handler:function(){
					var selectAntCode1=$("#selectDrug1").combobox("getValue");
					if (selectAntCode1!="")selectAntCodeArr.push(selectAntCode1);
					var selectAntCode2=$("#selectDrug2").combobox("getValue");
					if (selectAntCode2!="")selectAntCodeArr.push(selectAntCode2);
					for (var i = 0; i < selectAntCodeArr.length; i++) 
					{
						for (var i = 0; i < selJsonData.length; i++) {
							var item = selJsonData[i];
							var code=item.Code;
							if($.inArray(code,selectAntCodeArr) >-1)
							{
								jsonData.push(item);
							}
						}
					}
					if (selectAntCodeArr.length>0)
					{										
						//jsonData=JSON.stringify(jsonData);
						setViewAttribute(jsonData);		
					}			
					BPCDrugDlgObj.close();
				}				
			},{
				text:"关闭",
				handler:function(){					
					BPCDrugDlgObj.close();
				}
			}],			
			onClose:function(){  
                //setDialogValue();
            } 
		})
}
//抗凝药品显示内容
function setViewAttribute(jsonData)
{
	changeAnticoagulantList.length=0;
	var fieldset = document.getElementById("fieldset");
	fieldset.setAttribute("style","display:none;");		
	for (var i = 0; i < jsonData.length; i++) {
		var item = jsonData[i];					
		//label
		var child = document.createElement("label");
		child.setAttribute("style","padding-right:5px;padding-left:10px;");
		child.setAttribute("code","label"+item.Id);
		child.innerText = item.Desc+": ";
		fieldset.appendChild(child);
							
		var changeanticoagulant=[];
		var changeanticoagulantOptions=[];
		for (var j = 0; j < item.Options.length; j++) {
			//label
			var child = document.createElement("label");
			child.setAttribute("style","padding-right:10px;");
			child.setAttribute("code","label"+item.Id+item.Options[j].Code);
			child.innerText = item.Options[j].Desc;
			fieldset.appendChild(child);
        	//hisui-textbox
			var child = document.createElement("input");
        	//child.setAttribute("id","DrugDataId"+item.Code);
        	child.setAttribute("class","hisui-textbox");
        	child.setAttribute("style","padding-right:5px;padding-left:10px;border-radius:2px;margin-radius:2px;border:1px solid #9ED2F2");
        	child.setAttribute("code",item.Id+item.Options[j].Code);
        	child.setAttribute("name",item.Id+item.Options[j].Code);        	
        	//child.setAttribute("type","hisui-textbox");
        	if(item.Options[j].Code=="Note") child.style.width ="400px"; //其他
			else child.style.width ="40px";;
        	//if(item.Options[j].Code=="Note") child.setAttribute("style","width:400px"); //其他
			//else child.setAttribute("style","width:40px");
			child.setAttribute("data-options","required:true");	
			if ((item.Options[j].Value!="")&&(item.Options[j].Value!=undefined))
			{
				child.setAttribute("value",item.Options[j].Value );
			}		
			fieldset.appendChild(child);
			//span
			var child = document.createElement("span");
			child.setAttribute("style","padding-right:5px;padding-left:5px;");
			child.setAttribute("code","span"+item.Id+item.Options[j].Code);
			child.innerText = item.Options[j].Unit+" ";
			fieldset.appendChild(child);
			//fieldset.style.cssText ="display:block;";
			fieldset.setAttribute("style","display:block;border:1px solid #e2e2e2;height:26px;padding-top:2px;");
			changeanticoagulantOptions.push(item.Options[j].Code);
		}
		changeanticoagulant["DrugId"]=item.Id;
		changeanticoagulant["anticoagulantOptions"]=changeanticoagulantOptions;
		changeAnticoagulantList.push(changeanticoagulant);
	}
}
//抗凝方式选择抗凝药品
function gradeChange(antId) {
    //根据选择抗凝加载药品数据
    if (antId<0) {alert(antId); return;}
	var html ="";
	$.m({
		ClassName: "web.DHCBPDialysisApp",
		MethodName: "GetDrugByModeId",
		dialysisAppId:selDialysisAppId,
		antId: antId
		}, function(jsonData){
			jsonData=JSON.parse(jsonData);

			var fieldset = document.getElementById("fieldset");			
			//清除fieldset下所有标签
			var childs = fieldset.childNodes; 
			
			for(var i = childs.length - 1; i >= 0; i--) { 
  				fieldset.removeChild(childs[i]); 
			}
			if (selDialysisAppId!="") //列表选中一行数据
			{
				var viewJsonData = []
				for (var i = 0; i < jsonData.length; i++)
				{
					var item = jsonData[i];	
					var isValue=0;
					for (var j = 0; j < item.Options.length; j++) {
						if ((item.Options[j].Value!="")&&(item.Options[j].Value!=undefined))
						{
							isValue=1
						}
					}
					if (isValue) viewJsonData.push(item);
				}
				setViewAttribute(viewJsonData);
			}
			else //非列表选择
			{
				//选择药品显示界面				
				selJsonData.length = 0;						
				dispalyChild(jsonData);	
				//非选择药品显示界面		
				if(selJsonData.length<2)
				{
					//抗凝药品显示内容
					setViewAttribute(jsonData);
				}
			}
			selDialysisAppId=""
						
		});		
}

function setAnticoagulantList() {
	//抗凝用药
	anticoagulantStr="",ifAntValue=0
	if(changeAnticoagulantList.length!=0){
		var anticoagulantPara={};
		//anticoagulantPara["ArrangeId"]=arrangeId;
		var Drug=[];			
		for(var i=0;i<changeAnticoagulantList.length;i++){
			var anticoagulant=changeAnticoagulantList[i];
			var Drugs={};
			Drugs["DrugId"]=anticoagulant.DrugId;
			if (anticoagulantStr=="") anticoagulantStr=$("[code="+"label"+anticoagulant.DrugId+"]").text();
			else anticoagulantStr=anticoagulantStr+" "+ $("[code="+"label"+anticoagulant.DrugId+"]").text();
			var Options=[];
			for(var j=0;j<anticoagulant.anticoagulantOptions.length;j++){
				var Option={};
				var Code=anticoagulant.anticoagulantOptions[j];
				var Value=$("[code="+anticoagulant.DrugId+anticoagulant.anticoagulantOptions[j]+"]").val();
				Option["Code"]=Code;
				Option["Value"]=Value;
				if (Value=="") ifAntValue=1			
				Options.push(Option);
				Drugs["Options"]=Options;
				var desc=$("[code="+"label"+anticoagulant.DrugId+anticoagulant.anticoagulantOptions[j]+"]").text();
				var value=$("[code="+anticoagulant.DrugId+anticoagulant.anticoagulantOptions[j]+"]").val();
				if (value=="") ifAntValue=1	
				var unit=$("[code="+"span"+anticoagulant.DrugId+anticoagulant.anticoagulantOptions[j]+"]").text();
				if (anticoagulantStr=="") anticoagulantStr=""+desc+""+value+""+unit;
				else anticoagulantStr=anticoagulantStr+" "+ desc+""+value+""+unit;
			}
			Drug.push(Drugs);
		}
		anticoagulantPara["Drug"]=Drug;
	}
	return 	anticoagulantPara
}	
$(function(){
    initPageDefault(); 
    
    var dialysisAppObj=$HUI.datagrid("#BPDialysisApp",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBPDialysisApp",
			QueryName:"FindBPDialysisApp",
			admId:EpisodeID
			//locId:LocID
		},		
        columns:[[
			{ field: "id", title: "编号", width: 50 , hidden:true},
			{ field: "patName", title: "姓名", width: 60 },
			{ field: "papmiMedicare", title: "住院号", width: 80 },
			{ field: "admId", title: "就诊号", width: 80},			
			{ field: "ctlocId", title: "ctlocId", width: 100 , hidden:true},
			<!--{ field: "ctlocDesc", title: "科室", width: 140 },-->
			{ field: "wardId", title: "wardId", width: 100 , hidden:true},
			{ field: "wardDesc", title: "病房", width: 150 },
			{ field: "bedId", title: "bedId", width: 100 , hidden:true},
			{ field: "bedDesc", title: "床位", width: 50 },				
			{ field: "status", title: "status", width: 80, hidden:true },
			{ field: "statusDesc", title: "状态", width: 60 },
			{ field: "dialysisStatus", title: "dialysisStatus", width: 100 , hidden:true},
            { field: "dialysisStatusDesc", title: "透析状态", width: 70 },            
            { field: "infectiousCode", title: "infectiousCode", width: 100 , hidden:true},		
            { field: "infectiousDesc", title: "传染病", width: 70 },
            { field: "arrangePlan", title: "arrangePlan", width: 100 , hidden:true},           
            { field: "arrangePlanDesc", title: "排班计划", width: 100 },
            { field: "appDate", title: "透析日期", width: 90 },
			{ field: "appTime", title: "appTime", width: 100 , hidden:true},
			{ field: "vascularAccess", title: "vascularAccess", width: 100 , hidden:true},
            { field: "vascularAccessDesc", title: "血管通路", width: 120 },
            { field: "bodySite", title: "bodySite", width: 100 , hidden:true},
            { field: "bodySiteDesc", title: "部位", width: 60 },
            { field: "anticoagulantMode", title: "anticoagulantMode", width: 100 , hidden:true},
            { field: "anticoagulantModeDesc", title: "抗凝方式", width: 125 },
            { field: "anticoagulantDrug", title: "抗凝剂量", width: 100 },
            { field: "bpMode", title: "bpMode", width: 100 , hidden:true},
            { field: "bpModeDesc", title: "治疗方式", width: 120 },
            { field: "planTherapyDuration", title: "治疗时间", width: 60 },
            { field: "bpBFR", title: "血流速", width: 50 },
            { field: "dewaterAmount", title: "净超滤量", width: 65 },
            { field: "bpK", title: "透析液钾", width: 65 },
            { field: "bpCa2", title: "透析液钙", width: 65 },
            { field: "bpNa", title: "透析液钠", width: 65 },
            { field: "bpNote", title: "备注", width: 120 },
        
            { field: "userId", title: "userId", width: 100 , hidden:true},
            { field: "bpPhoneNum", title: "联系电话", width: 80 },            
            { field: "userDesc", title: "创建用户", width: 80 },             
            { field: "updateDate", title: "创建日期", width: 90 },
            { field: "updateTime", title: "创建时间", width: 80 },
        ]],
		//title:"血液净化列表",
		pagination:true,
		pageSize: 15,
		pageList: [15, 30, 50],
		fit:true,
		//fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyui取消单击行选中状态
		selectOncheck:true,
        iconCls:'icon-paper',
        rownumbers: true,
		onSelect:function(rowIndex,rowData){			
			if(!IsCheckFlag){				
				IsCheckFlag = true;
				selRowIndex=rowIndex;
				selDialysisAppId=rowData.id;
				setSelectData(rowData);
				}			
			else if(selRowIndex==rowIndex){
				IsCheckFlag = false;
				selDialysisAppId="";
				clearControlValue();
				$('#BPDialysisApp').datagrid("unselectRow",rowIndex);
			}else{
				$("#AnticoagulantMode").combobox('setText',"");
				//$("#AnticoagulantMode").combobox('setValue',"");
				IsCheckFlag = true;
				selRowIndex=rowIndex;
				selDialysisAppId=rowData.id;
				setSelectData(rowData);
			}			
			
					
		}

	}) 
	
	$("#btnSave").click(function(){						
    	var userId=session["LOGON.USERID"];
    	var status="A"
		var infectious=$("#InfectiousDiseaseInfo").combogrid('grid').datagrid('getSelections');
		var r=""
		if (infectious.length>0)
		{
			var r=infectious[0].Code;					
			for(var i=1;i<infectious.length;i++)
			{
				r=r+","+infectious[i].Code
			}
		}
		var infectious=r;
		var arrangePara={};
		arrangePara.admId=EpisodeID;
		arrangePara.userId=userId;			
		arrangePara.appDate=$("#AppDate").datebox("getValue");    	
    	arrangePara.dialysisStatus=$("#DialysisStatus").combobox("getValue");
    	arrangePara.arrangePlan=$("#ArrangePlan").combobox("getValue");
    	arrangePara.vascularAccess=$("#VascularAccess").combobox("getValue");
    	arrangePara.bodySite=$("#BodySite").combobox("getValue");
    	arrangePara.anticoagulantMode=$("#AnticoagulantMode").combobox("getValue");    	
    	arrangePara.bpMode=$("#BPMode").combobox("getValue");
    	arrangePara.planTherapyDuration=$("#PlanTherapyDuration").val();    	
    	arrangePara.bpBFR=$("#BFR").val();
    	arrangePara.dewaterAmount=$("#DewaterAmount").val();
    	arrangePara.bpK=$("#K").val();
    	arrangePara.bpCa2=$("#Ca2").val();
    	arrangePara.bpNa=$("#Na").val();
    	arrangePara.bpNote=$("#Note").val();
    	arrangePara.bpPhoneNum=$("#PhoneNum").val();
    	arrangePara.status=status
		arrangePara.infectious=infectious
		//抗凝药品
		var anticoagulantPara=setAnticoagulantList();
		arrangePara.anticoagulantDrug=anticoagulantStr;
		if ((anticoagulantPara=="undefined")||(anticoagulantPara==null))
		{
			$.messager.alert("提示", "抗凝方式不能为空", "error");
            return;
		}
		if (ifAntValue==1)
		{
			$.messager.alert("提示", "抗凝剂量不能为空", "error");
            return;
		}
		if (arrangePara.vascularAccess=="")
		{
			$.messager.alert("提示", "血管通路不能为空", "error");
            return;
		}
		if (arrangePara.bpMode=="")
		{
			$.messager.alert("提示", "治疗方式不能为空", "error");
            return;
		}
		if((arrangePara.bpBFR!="")&&((arrangePara.bpBFR<50)||(arrangePara.bpBFR>10000)))
		{
			$.messager.alert("提示", "血流速值范围是50-10000，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpK!="")&&((arrangePara.bpK<2)||(arrangePara.bpK>3)))
		{
			$.messager.alert("提示", "透析液钾值范围是2-3，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpCa2!="")&&((arrangePara.bpCa2<1.25)||(arrangePara.bpCa2>1.75)))
		{
			$.messager.alert("提示", "透析液钙值范围是1.25-1.75，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpNa!="")&&((arrangePara.bpNa<130)||(arrangePara.bpNa>200)))
		{
			$.messager.alert("提示", "透析液钠值范围是130-200，超出范围请重新输入", "error");
            return;
		}			
    	$.messager.confirm("确认","确认新增血液净化申请吗？",function(r){
		if(r)
		{
			var success=$.m({
            	ClassName:"web.DHCBPDialysisApp",
        		MethodName:"SaveBPDialysisApp",
     			arrangePara:JSON.stringify(arrangePara),
     			anticoagulantPara:JSON.stringify(anticoagulantPara)
        	},false);
       	 	//alert(success);
        	if(success>0)
        	{
	        	$.messager.alert("提示", "新增成功！", "info"); 
	        	dialysisAppObj.load();
	        	clearControlValue();       		
        	}
        	else
            {
                $.messager.alert("提示", success, "error");
            	return;
            }			
		}
     	})
   	}); 
    $("#btnEdit").click(function(){
	    var r=""
	    var infectious=$("#InfectiousDiseaseInfo").combogrid('grid').datagrid('getSelections');
	    if (infectious.length>0)
		{
			var r=infectious[0].Code;					
			for(var i=1;i<infectious.length;i++)
			{
				r=r+","+infectious[i].Code
			}
		}
		var row=$("#BPDialysisApp").datagrid("getSelected");
		if(!row) {$.messager.alert("提示","请先选择透析申请","error"); return;}		
		var infectious=r;   						
    	var userId=session["LOGON.USERID"];
		var status=$("#BPDialysisApp").datagrid("getSelected").status;
		if (status=="R") {$.messager.alert("提示","此透析申请已登记，不能修改","error"); return;}		
		var arrangePara={};
		arrangePara.id=$("#BPDialysisApp").datagrid("getSelected").id;		
		arrangePara.appDate=$("#AppDate").datebox("getValue"); 
		arrangePara.status=status;
		arrangePara.infectious=infectious;    	
    	arrangePara.dialysisStatus=$("#DialysisStatus").combobox("getValue");
    	arrangePara.arrangePlan=$("#ArrangePlan").combobox("getValue");    	
    	arrangePara.vascularAccess=$("#VascularAccess").combobox("getValue");
    	arrangePara.bodySite=$("#BodySite").combobox("getValue");
    	arrangePara.anticoagulantMode=$("#AnticoagulantMode").combobox("getValue");    	 	
    	arrangePara.bpMode=$("#BPMode").combobox("getValue");
		arrangePara.planTherapyDuration=$("#PlanTherapyDuration").val(); 
		arrangePara.bpBFR=$("#BFR").val(); 
		arrangePara.dewaterAmount=$("#DewaterAmount").val(); 
		arrangePara.bpK=$("#K").val(); 
		arrangePara.bpCa2=$("#Ca2").val(); 
		arrangePara.bpNa=$("#Na").val();		
		arrangePara.bpNote=$("#Note").val();
		arrangePara.bpPhoneNum=$("#PhoneNum").val();
		arrangePara.userId=userId		
		//抗凝药品
		var anticoagulantPara=setAnticoagulantList();
		arrangePara.anticoagulantDrug=anticoagulantStr;
		if ((anticoagulantPara=="undefined")||(anticoagulantPara==null))
		{
			$.messager.alert("提示", "抗凝方式不能为空", "error");
            return;
		}
		if (ifAntValue==1)
		{
			$.messager.alert("提示", "抗凝剂量不能为空", "error");
            return;
		}
		if (arrangePara.vascularAccess=="")
		{
			$.messager.alert("提示", "血管通路不能为空", "error");
            return;
		}
		if (arrangePara.bpMode=="")
		{
			$.messager.alert("提示", "治疗方式不能为空", "error");
            return;
		}
		if((arrangePara.bpBFR!="")&&((arrangePara.bpBFR<50)||(arrangePara.bpBFR>10000)))
		{
			$.messager.alert("提示", "血流速值范围是50-10000，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpK!="")&&((arrangePara.bpK<2)||(arrangePara.bpK>3)))
		{
			$.messager.alert("提示", "透析液钾值范围是2-3，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpCa2!="")&&((arrangePara.bpCa2<1.25)||(arrangePara.bpCa2>1.75)))
		{
			$.messager.alert("提示", "透析液钙值范围是1.25-1.75，超出范围请重新输入", "error");
            return;
		}
		if((arrangePara.bpNa!="")&&((arrangePara.bpNa<130)||(arrangePara.bpNa>200)))
		{
			$.messager.alert("提示", "透析液钠值范围是130-200，超出范围请重新输入", "error");
            return;
		}
    	$.messager.confirm("确认","确认修改血液净化申请吗？",function(r){
		if(r)
		{
			var success=$.m({
            	ClassName:"web.DHCBPDialysisApp",
        		MethodName:"UpdateBPDialysisApp",
        		arrangePara:JSON.stringify(arrangePara),
     			anticoagulantPara:JSON.stringify(anticoagulantPara)
        	},false);
       	 	//alert(success);
        	if(success>0)
        	{
	        	$.messager.alert("提示", "修改成功！", "info"); 
	        	dialysisAppObj.load();
	        	clearControlValue();       		
        	}
        	else
            {
                $.messager.alert("提示", success, "error");
            	return;
            }			
		}
    	})
 	});
 	$("#btnDelete").click(function(){
	 	var infectious=$("#InfectiousDiseaseInfo").combogrid('grid').datagrid('getSelections');
	 	var row=$("#BPDialysisApp").datagrid("getSelected");
		if(!row) {$.messager.alert("提示","请先选择透析申请","error"); return;}	
    	var userId=session["LOGON.USERID"];    	
		var id=$("#BPDialysisApp").datagrid("getSelected").id;		
		var status=$("#BPDialysisApp").datagrid("getSelected").status;
		if (status=="R") {$.messager.alert("提示","此透析申请已登记，不能删除","error"); return;}
    	$.messager.confirm("确认","确认删除血液净化申请吗？",function(r){
		if(r)
		{
			var success=$.m({
            	ClassName:"web.DHCBPDialysisApp",
        		MethodName:"DeleteBPDialysisApp",
        		id:id,
            	userId:userId
        	},false);
       	 	//alert(success);
        	if(success>0)
        	{
	        	$.messager.alert("提示", "删除成功！", "info"); 
	        	dialysisAppObj.load();       		
        	}
        	else
            {
                $.messager.alert("提示", success, "error");
            	return;
            }			
		}
    	})
 	});

})
