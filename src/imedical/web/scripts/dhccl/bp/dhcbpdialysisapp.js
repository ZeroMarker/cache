var PatientID = "";     /// ����ID
var EpisodeID = "";     /// ���˾���ID
var mradm = "";			/// �������ID
var CsType = "";        /// ��������
var LocID = "";     /// ����
var selDialysisAppId="" //
var IsCheckFlag=false;//�Ƿ�ѡ�еı�־
var selRowIndex;//���浱ǰѡ����
var LgGroup = session['LOGON.GROUPDESC'];
//var getDate=new Date();
//var resDate=format(getDate,'dd/MM/yyyy');

var changeAnticoagulantList=[];
var anticoagulantStr="",ifAntValue=0;
var selJsonData= new Array();
var locId=197;
/// ҳ���ʼ������
function initPageDefault(){

	InitPatEpisodeID();       /// ��ʼ�����ز��˾���ID
	InitFormItem();
	GetPatBaseInfo();         /// ���˾�����Ϣ
	
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

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	PatientID = dhccl.getUrlParam("PatientID");  /// ����ID
	EpisodeID = dhccl.getUrlParam("EpisodeID");  /// ����ID
	mradm = dhccl.getUrlParam("mradm");          /// �������ID
	CsType = dhccl.getUrlParam("CsType");        /// ��������
	LocID=session['LOGON.CTLOCID']; //��ǰ����
}

/// ���˾�����Ϣ
function GetPatBaseInfo(){
	runClassMethod("web.DHCBPDialysisApp","GetPatEssInfo",{"PatientID":"", "EpisodeID":EpisodeID},function(jsonString){
		//var jsonObject = JSON.parse(jsonString);
		var jsonObject = jsonString;
		$('.ui-span-m').each(function(){
			$(this).text(jsonObject[this.id]);
			//alert(jsonObject[this.id]);
			if (this.id=="PatSex")
			{
				if (jsonObject.PatSex == "��"){
					$("#PatPhoto").attr("src","../scripts/dhcclinic/images/boy.png");
				}else if (jsonObject.PatSex == "Ů"){
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
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
	    	return;
	    }
	}
}
///combogrid����ѡ�񣬶�ѡ��������ʾ
function OnHidePanel3(item)
{
	var idField = $(item).combogrid("options").idField;
	var vals = $(item).combogrid("getValues");  //��ǰcombobox��ֵ
	var txt = $(item).combogrid("getText");
	var allData = $(item).combogrid("grid").datagrid('getSelections');   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
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
	    	$.messager.alert("��ʾ","���������ѡ��","error");
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
        data:[{'Code':"HBV",'Desc':"�Ҹ�"}
        ,{'Code':"HCV",'Desc':"����"}
        ,{'Code':"HIV",'Desc':"���̲�"}
		,{'Code':"SP",'Desc':"÷��"}
        ,{'Code':"Negative",'Desc':"����"}],  
        columns:[[
			{filed:"Code",checkbox:true,width:0},
			{field:"Desc",title:"ȫѡ",width:"100"}
		]],		
		onHidePanel: function () {
        	OnHidePanel3("#InfectiousDiseaseInfo");
        }     	
	});		
	$HUI.combobox("#DialysisStatus",{
		valueField:"Code",
		textField:'Desc',
		panelHeight:'auto',
        data:[{'Code':"G",'Desc':"�յ�͸��"}
        ,{'Code':"K",'Desc':"ά��͸��"}
        ,{'Code':"T",'Desc':"������"}
		],  
		onHidePanel: function () {
        	OnHidePanel("#DialysisStatus");
        }
	 });
	 $HUI.combobox("#ArrangePlan",{
		valueField:"Code",
		textField:'Desc',
		panelHeight:'auto',
        data:[{'Code':"G3",'Desc':"�յ�3��"}
        ,{'Code':"K3",'Desc':"ά��3��1��"}
        ,{'Code':"T1",'Desc':"��ʱ1��,֮����"}
        ,{'Code':"T2",'Desc':"��ʱ2��,֮����"}
        ,{'Code':"T3",'Desc':"��ʱ3��,֮����"}
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
	//����ѡ��ҩƷ
	$HUI.combobox("#selectDrug1",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        onHidePanel: function () {
        	OnHidePanel("#selectDrug1");
        }
    })
    //����ѡ��ҩƷ
	$HUI.combobox("#selectDrug2",{
        valueField:"Code",
        textField:"Desc",
        panelHeight:'auto',
        onHidePanel: function () {
        	OnHidePanel("#selectDrug2");
        }
    })
}

//��ʼ�������б�
function initPatientsList(){    
	var locId=session['LOGON.CTLOCID'];
    $("#loc").next(".combo").find(".combo-text").prop("placeholder", "����");
    //$("#patientWard").next(".combo").find(".combo-text").prop("placeholder", "����");	
}
//ѡ���б������ݴ���¼���
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
//ȡ��ѡ���б�ʱ���¼���
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

//ȥ���ظ���Ŀ
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
//�����ʾ����Ŀ
function dispalyChild(jsonData) {
	var catValArr = new Array()
	selJsonData.length=0;
	//ѭ����ȡȫ������ķ���id
	for (var i = 0; i < jsonData.length; i++) {
		var item = jsonData[i];
		var catNum=item.Cat;
		if (catNum>0) 
		{
			catValArr.push(catNum)
		}
	}
	//ȥ���ظ��ķ���id
	catValArr=newArrFunc(catValArr);
	//ɸѡ������������ҩƷ��Ŀ
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
//��ʾҩƷѡ����
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
			title:'���ҩƷѡ��',
			buttons:[{
				text:"����",
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
				text:"�ر�",
				handler:function(){					
					BPCDrugDlgObj.close();
				}
			}],			
			onClose:function(){  
                //setDialogValue();
            } 
		})
}
//����ҩƷ��ʾ����
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
        	if(item.Options[j].Code=="Note") child.style.width ="400px"; //����
			else child.style.width ="40px";;
        	//if(item.Options[j].Code=="Note") child.setAttribute("style","width:400px"); //����
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
//������ʽѡ����ҩƷ
function gradeChange(antId) {
    //����ѡ��������ҩƷ����
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
			//���fieldset�����б�ǩ
			var childs = fieldset.childNodes; 
			
			for(var i = childs.length - 1; i >= 0; i--) { 
  				fieldset.removeChild(childs[i]); 
			}
			if (selDialysisAppId!="") //�б�ѡ��һ������
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
			else //���б�ѡ��
			{
				//ѡ��ҩƷ��ʾ����				
				selJsonData.length = 0;						
				dispalyChild(jsonData);	
				//��ѡ��ҩƷ��ʾ����		
				if(selJsonData.length<2)
				{
					//����ҩƷ��ʾ����
					setViewAttribute(jsonData);
				}
			}
			selDialysisAppId=""
						
		});		
}

function setAnticoagulantList() {
	//������ҩ
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
			{ field: "id", title: "���", width: 50 , hidden:true},
			{ field: "patName", title: "����", width: 60 },
			{ field: "papmiMedicare", title: "סԺ��", width: 80 },
			{ field: "admId", title: "�����", width: 80},			
			{ field: "ctlocId", title: "ctlocId", width: 100 , hidden:true},
			<!--{ field: "ctlocDesc", title: "����", width: 140 },-->
			{ field: "wardId", title: "wardId", width: 100 , hidden:true},
			{ field: "wardDesc", title: "����", width: 150 },
			{ field: "bedId", title: "bedId", width: 100 , hidden:true},
			{ field: "bedDesc", title: "��λ", width: 50 },				
			{ field: "status", title: "status", width: 80, hidden:true },
			{ field: "statusDesc", title: "״̬", width: 60 },
			{ field: "dialysisStatus", title: "dialysisStatus", width: 100 , hidden:true},
            { field: "dialysisStatusDesc", title: "͸��״̬", width: 70 },            
            { field: "infectiousCode", title: "infectiousCode", width: 100 , hidden:true},		
            { field: "infectiousDesc", title: "��Ⱦ��", width: 70 },
            { field: "arrangePlan", title: "arrangePlan", width: 100 , hidden:true},           
            { field: "arrangePlanDesc", title: "�Ű�ƻ�", width: 100 },
            { field: "appDate", title: "͸������", width: 90 },
			{ field: "appTime", title: "appTime", width: 100 , hidden:true},
			{ field: "vascularAccess", title: "vascularAccess", width: 100 , hidden:true},
            { field: "vascularAccessDesc", title: "Ѫ��ͨ·", width: 120 },
            { field: "bodySite", title: "bodySite", width: 100 , hidden:true},
            { field: "bodySiteDesc", title: "��λ", width: 60 },
            { field: "anticoagulantMode", title: "anticoagulantMode", width: 100 , hidden:true},
            { field: "anticoagulantModeDesc", title: "������ʽ", width: 125 },
            { field: "anticoagulantDrug", title: "��������", width: 100 },
            { field: "bpMode", title: "bpMode", width: 100 , hidden:true},
            { field: "bpModeDesc", title: "���Ʒ�ʽ", width: 120 },
            { field: "planTherapyDuration", title: "����ʱ��", width: 60 },
            { field: "bpBFR", title: "Ѫ����", width: 50 },
            { field: "dewaterAmount", title: "��������", width: 65 },
            { field: "bpK", title: "͸��Һ��", width: 65 },
            { field: "bpCa2", title: "͸��Һ��", width: 65 },
            { field: "bpNa", title: "͸��Һ��", width: 65 },
            { field: "bpNote", title: "��ע", width: 120 },
        
            { field: "userId", title: "userId", width: 100 , hidden:true},
            { field: "bpPhoneNum", title: "��ϵ�绰", width: 80 },            
            { field: "userDesc", title: "�����û�", width: 80 },             
            { field: "updateDate", title: "��������", width: 90 },
            { field: "updateTime", title: "����ʱ��", width: 80 },
        ]],
		//title:"ѪҺ�����б�",
		pagination:true,
		pageSize: 15,
		pageList: [15, 30, 50],
		fit:true,
		//fitColumns:true,
		headerCls:"panel-header-gray",
		singleSelect:true,
		checkOnSelect:true,	///easyuiȡ��������ѡ��״̬
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
		//����ҩƷ
		var anticoagulantPara=setAnticoagulantList();
		arrangePara.anticoagulantDrug=anticoagulantStr;
		if ((anticoagulantPara=="undefined")||(anticoagulantPara==null))
		{
			$.messager.alert("��ʾ", "������ʽ����Ϊ��", "error");
            return;
		}
		if (ifAntValue==1)
		{
			$.messager.alert("��ʾ", "������������Ϊ��", "error");
            return;
		}
		if (arrangePara.vascularAccess=="")
		{
			$.messager.alert("��ʾ", "Ѫ��ͨ·����Ϊ��", "error");
            return;
		}
		if (arrangePara.bpMode=="")
		{
			$.messager.alert("��ʾ", "���Ʒ�ʽ����Ϊ��", "error");
            return;
		}
		if((arrangePara.bpBFR!="")&&((arrangePara.bpBFR<50)||(arrangePara.bpBFR>10000)))
		{
			$.messager.alert("��ʾ", "Ѫ����ֵ��Χ��50-10000��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpK!="")&&((arrangePara.bpK<2)||(arrangePara.bpK>3)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��2-3��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpCa2!="")&&((arrangePara.bpCa2<1.25)||(arrangePara.bpCa2>1.75)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��1.25-1.75��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpNa!="")&&((arrangePara.bpNa<130)||(arrangePara.bpNa>200)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��130-200��������Χ����������", "error");
            return;
		}			
    	$.messager.confirm("ȷ��","ȷ������ѪҺ����������",function(r){
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
	        	$.messager.alert("��ʾ", "�����ɹ���", "info"); 
	        	dialysisAppObj.load();
	        	clearControlValue();       		
        	}
        	else
            {
                $.messager.alert("��ʾ", success, "error");
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
		if(!row) {$.messager.alert("��ʾ","����ѡ��͸������","error"); return;}		
		var infectious=r;   						
    	var userId=session["LOGON.USERID"];
		var status=$("#BPDialysisApp").datagrid("getSelected").status;
		if (status=="R") {$.messager.alert("��ʾ","��͸�������ѵǼǣ������޸�","error"); return;}		
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
		//����ҩƷ
		var anticoagulantPara=setAnticoagulantList();
		arrangePara.anticoagulantDrug=anticoagulantStr;
		if ((anticoagulantPara=="undefined")||(anticoagulantPara==null))
		{
			$.messager.alert("��ʾ", "������ʽ����Ϊ��", "error");
            return;
		}
		if (ifAntValue==1)
		{
			$.messager.alert("��ʾ", "������������Ϊ��", "error");
            return;
		}
		if (arrangePara.vascularAccess=="")
		{
			$.messager.alert("��ʾ", "Ѫ��ͨ·����Ϊ��", "error");
            return;
		}
		if (arrangePara.bpMode=="")
		{
			$.messager.alert("��ʾ", "���Ʒ�ʽ����Ϊ��", "error");
            return;
		}
		if((arrangePara.bpBFR!="")&&((arrangePara.bpBFR<50)||(arrangePara.bpBFR>10000)))
		{
			$.messager.alert("��ʾ", "Ѫ����ֵ��Χ��50-10000��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpK!="")&&((arrangePara.bpK<2)||(arrangePara.bpK>3)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��2-3��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpCa2!="")&&((arrangePara.bpCa2<1.25)||(arrangePara.bpCa2>1.75)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��1.25-1.75��������Χ����������", "error");
            return;
		}
		if((arrangePara.bpNa!="")&&((arrangePara.bpNa<130)||(arrangePara.bpNa>200)))
		{
			$.messager.alert("��ʾ", "͸��Һ��ֵ��Χ��130-200��������Χ����������", "error");
            return;
		}
    	$.messager.confirm("ȷ��","ȷ���޸�ѪҺ����������",function(r){
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
	        	$.messager.alert("��ʾ", "�޸ĳɹ���", "info"); 
	        	dialysisAppObj.load();
	        	clearControlValue();       		
        	}
        	else
            {
                $.messager.alert("��ʾ", success, "error");
            	return;
            }			
		}
    	})
 	});
 	$("#btnDelete").click(function(){
	 	var infectious=$("#InfectiousDiseaseInfo").combogrid('grid').datagrid('getSelections');
	 	var row=$("#BPDialysisApp").datagrid("getSelected");
		if(!row) {$.messager.alert("��ʾ","����ѡ��͸������","error"); return;}	
    	var userId=session["LOGON.USERID"];    	
		var id=$("#BPDialysisApp").datagrid("getSelected").id;		
		var status=$("#BPDialysisApp").datagrid("getSelected").status;
		if (status=="R") {$.messager.alert("��ʾ","��͸�������ѵǼǣ�����ɾ��","error"); return;}
    	$.messager.confirm("ȷ��","ȷ��ɾ��ѪҺ����������",function(r){
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
	        	$.messager.alert("��ʾ", "ɾ���ɹ���", "info"); 
	        	dialysisAppObj.load();       		
        	}
        	else
            {
                $.messager.alert("��ʾ", success, "error");
            	return;
            }			
		}
    	})
 	});

})
