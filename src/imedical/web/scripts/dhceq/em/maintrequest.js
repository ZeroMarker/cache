//var FromDeptStr=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","503014");  //��Ч����
var SubmitFlag=false;
var ObjData=""
//�������
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
/**
 * ��ʼ��������Ϣ
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initDocument()
{
	initUserInfo();
	initMessage("Maint");
	var e1=$('#MRReplaceFlag').attr('disabled') ;
	muilt_Tab();
	setElement("VGroupType","")	///zc 2022-11-17
	//��ť����
	setEnabled();
	var MaintType=getElementValue("MRMaintType");
	var Status=getElementValue("MRStatus");
	var QXType=getElementValue("QXType");
	fillData(); //modify by zyq �޸�filldataλ���Ի�ȡEquipDR 2023-1-11
	if ((Status=="")||(Status==0))
	{
		initEquipNameTree(); // ��ʼ���豸��
		initkeywords();		// ��ʼ���Ҳ��ѯ�����ؼ���
		initRepairFlagData(); // ���ذ�ť��ʼ��
		initLocTree();	// ��ʼ��������
		if ((MaintType!=1)&&(QXType==2))
		{
			//$('#MRRequestLocDR_LocDesc').combotree('setValue',curLocName);
			setElement("MRRequestLocDR_LocDesc",curLocName);
			setElement("MRRequestLocDR",curLocID);
			var DeptTel=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","depttel",curLocID);
			setElement("MRRequestLocTel",DeptTel);
			setElement("MRRequestUserDR_UserName",curUserName);
			setElement("MRRequestUserDR",curUserID);
			var UserTel=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","usertel",curUserID);
			setElement("MRRequestTel",UserTel);
			setElement("UseLocDR",curLocID);
			setElement("UseLocDR_LocDesc",curLocName);
			disableElement("UseLocDR_LocDesc",true);
			//add by zyq 2022-11-30 begin
			hiddenObj("MRMaintGroupDR_MGDesc",1)
			hiddenObj("cMRMaintGroupDR_MGDesc",1)
			hiddenObj("MRAcceptUserDR_UserName",1)
			hiddenObj("cMRAcceptUserDR_UserName",1)
			hiddenObj("EmergencyLevelFlag",1)  //modified by wy 2023-4-6 3428539
			hiddenObj("cEmergencyLevelFlag",1)
			hiddenObj("SeverityLevelFlag",1)
			hiddenObj("cSeverityLevelFlag",1)
			//add by zyq 2022-11-30 end
		
		}
		if(MaintType==1){$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("MREquipDR"));}
		initMaintWaitListDataGrid();  // �����Ҳ��б�
	}
	else
	{
		initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("ActionCode"));
		$("#finishBtn").click(function(){panelBtnClick('finish');});
		$("#maintBtn").click(function(){panelBtnClick('maint');});
		$("#toRetrieveBtn").click(function(){panelBtnClick('toRetrieve');});
		$("#retrieveBtn").bind('click',function() {panelBtnClick('retrieve');});
		$("#changeGroupBtn").bind('click',function() {panelBtnClick('changeGroup');});
		$("#cancelBtn").bind('click',function() {panelBtnClick('cancel');});
		$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+getElementValue("MRExObjDR_EQRowID"));
		$("#AccessoryBtn").bind('click',function() {BMaintDetail_Click()}); //Modify by zx 2022-11-22ά�����
	}
	
	initApproveList();  //Modify by zx 2022-10-29 ������������
	//ˢ������
	
	//Modefied by zc 2022-11-22 begin
	if ((Status!="")&&(Status!=0))
	{
		totalFee_Change();
		setElementEnabled();
	}
	if (Status!="") {initApproveButton();} //modify by zyq 2023-03-23 3206533
	initPage();
	initButtonWidth("AccessoryBtn");
	$("#MREquipNameDiv").append('<a id="BAdd" href="#"><img style="vertical-align: middle;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png"/></a>');
	$("#BAdd").on("click", BAdd_Clicked);
	$("#BAdd").show();
}
/**
 * ����ʱ��ʼ���Ҳ��ѯ�����ؼ���
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initkeywords()
{
	var ActionItem = [];
	var Vallist=tkMakeServerCall("web.DHCEQ.Plat.LIBMessages","GetActionsByBussType",curGroupID,"31","1")  //Modefied by wy 2023-4-12
	Vallist=Vallist.replace(/\\n/g,"\n");	
	ActionItem.push({text:'����',id:''});
	ActionItem.push({text:'�ύ',id:'0'}); // add by wy 2023-3-1 3266968 
	var list=Vallist.split("$");
	for (var i=0;i<=list.length-1;i++)
	{
		var id=list[i].split(",")[0];
		var text=list[i].split(",")[1];   //Modefied by zc 2022-11-22 //tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID","Action",list[i])
		ActionItem.push({text:text,id:id});
	}
	ActionItem.push({text:'�����',id:'Aduit'}); // add by wy 2023-3-1 3266968 
	var Action =$("#Action").keywords({
	   	singleSelect:true,
       	items:ActionItem,
		onClick : function(v){
		var ActionDR=v.id
		setElement("ActionDR",ActionDR);
		}
    });
    //add by zyq begin 2023-03-07
    var EquipTypeItem = [];
	var Typelist=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","MaintType",curGroupID)
	EquipTypeItem.push({text:'����',id:''});
	var EquipTypelist=Typelist.split(",");
	//modified by wy 2023-4-12 3433890ȡֵ������0��ʼ
	for (var i=0;i<=EquipTypelist.length-1;i++)
	{
		var id=EquipTypelist[i].split("^")[0];
		var text=EquipTypelist[i].split("^")[1];  
		EquipTypeItem.push({text:text,id:id});
		
	}
   	var MREquipTypeFind =$("#MREquipTypeFind").keywords({
	   	singleSelect:true,
       	items:EquipTypeItem, //add by zyq end 2023-03-07
		onClick : function(v){
		setElement("MREquipTypeFindDR",v.id);
		}
    });
}
/**
 * ���뱨��ʱ�����豸�Ŵ�
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initEquipNameLookUp()
 {
	var SourceTypeDR="1"
	setElement("FacilityFlag","0")
	var vParams=[{name:'Equip',type:'4',value:'MREquipDR_EQName'},{name:'VUseLoc',type:'4',value:''},{name:'FacilityFlag',type:'4',value:'FacilityFlag'},{name:'vData',type:'2',value:"SSLocID=^SSGroupID=^SSUserID=^EquipAttribute=^vAllInFlag=Y"+"^MRSourceType="+SourceTypeDR}]
	singlelookup("MREquipDR_EQName","EM.L.Equip",vParams)
}
/**
 * ���뱨�޺����뱨���л���ť��ʼ��
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initRepairFlagData()
{
	$HUI.switchbox('#RepairFlag',{
        onText:'����',
        offText:'�豸',
        onClass:'info',
        offClass:'primary',
        onSwitchChange:function(e,obj){
	        $("#MREquipNameDiv").empty();
			$("#MREquipNameDiv").append('<input id="MREquipDR_EQName" class="hisui-validatebox textbox"><a id="BAdd" href="#"><img style="vertical-align: middle;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png"/></a>');
            if ($(this).switchbox('getValue'))
            {	
	          	setElement("MRSourceType","3")
				setElement("MREquipDR","")
				setElement("MREquipTypeDR","")
				initEquipNameTree();
				$("#BAdd").on("click",BAdd_Clicked);
				$("#BAdd").show();
            }
            else
            {
				setElement("MRSourceType","1")
	           	var SourceTypeDR=getElementValue("MRSourceType")
				setElement("FacilityFlag",SourceTypeDR-1)
				setElement("MREquipDR","")
				setElement("MREquipTypeDR","")
				var vParams=[{name:'Equip',type:'4',value:'MREquipDR_EQName'},{name:'VUseLoc',type:'4',value:''},{name:'FacilityFlag',type:'2',value:'0'},{name:'vData',type:'2',value:"SSLocID=^SSGroupID=^SSUserID=^EquipAttribute=^vAllInFlag=Y"+"^MRSourceType="+SourceTypeDR}]
	   			singlelookup("MREquipDR_EQName","EM.L.Equip",vParams);
				$("#BAdd").hide();
	        }
           
        },
        onInit:function(){
	        
	    }
    })
}
/**
 * ���뱨��ʱ��ʼ��Ϊ������
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initEquipNameTree()
{
	$cm({
		    ClassName:"web.DHCEQ.EM.BUSMMaintRequest",
		    MethodName:"GetBaseItem",
		    Desc: "", //getElementValue("MREquipDR_EQName"),  //ת��ѡ��ʱ��Ӱ�����ݼ���
		    GroupID:""
		},function(jsonData){
			$HUI.combotree('#MREquipDR_EQName',{
				panelWidth:360,
				panelHeight:300,
				editable:true,
				onChange: function (newValue, oldValue) {
				},
				onClick: function (node) 
				{
					if (node.children)
					{
						$('#MREquipDR_EQName').combotree('setValue',"");
						setElement("MREquipDR","")
						setElement("MREquipTypeDR","")
					}
					setElement("MREquipDR",node.id);
					setElement("MREquipDR_EQName",node.text);
					setElement("MREquipTypeDR",node.EquipTypeDR);
					setElement("MRExObjDR","");  //add by txr 20230423
			    	if(getElementValue("MRMaintType")==1) createMaintHistory(node.id);  //ά�޹���ʦ���޼�����ʷ��¼
					var PParams=[{name:'FaultCase',type:'4',value:'MRFaultCaseDR_FCDesc'},{name:'Equip',type:'2',value:node.id}]
					singlelookup("MRFaultCaseDR_FCDesc","EM.L.FaultCase",PParams)
					if(getElementValue("MREquipTypeDR")!="") //add by zyq 2022-12-04 begin ά�������
					{
                    PParams=[{name:'VGroupType',type:'2',value:curGroupID},{name:'VEquipTypeDR',type:'4',value:'MREquipTypeDR'}] //modified by wy 2023-4-17
					singlelookup("MRMaintGroupDR_MGDesc","EM.L.MaintGroup",PParams)
					$cm({
						ClassName:"web.DHCEQ.EM.LIBFind",
						QueryName:"MaintGroup",
						VEquipTypeDR:getElementValue("MREquipTypeDR"),
					},function(rs){
						if(rs.rows[0].TRowID){
						setElement("MRMaintGroupDR",rs.rows[0].TRowID)
						setElement("MRMaintGroupDR_MGDesc",rs.rows[0].TDesc)
						}
					
						});
					}//add by zyq 2022-12-04 end
					
					
				}

			}).loadData(jsonData.EquipType);
			//EquipName.loadData(jsonData.EquipType);  //{"name":"����"}
	});
}
/**
 * ��ʼ��������
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initLocTree()
{
	var TreeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","991111");
	if(TreeFlag==1) //modify by zyq 2023-03-17 3280807 begin
	{
		$cm({
		    ClassName:"web.DHCEQ.EM.BUSMMaintRequest",
		    MethodName:"GetBaseLocItem",
		    Desc: getElementValue("MRRequestLocDR_LocDesc")
		},function(jsonData){
			$HUI.combotree('#MRRequestLocDR_LocDesc',{
				panelWidth:360,
				panelHeight:400,
				editable:true,
				onChange: function (newValue, oldValue) {
				},
		    	onClick: function (node) 
		    	{
			    	if(node.clickFlag=="0")
			    	{
				    	$('#MRRequestLocDR_LocDesc').combotree('setValue',"");
						setElement("MRRequestLocDR","");
		           		setElement("MRRequestLocDR_LocDesc","");
		           		setElement("MRRequestLocTel","");
		           		return;
				    }
					setElement("MRRequestLocDR",node.id);
		           	setElement("MRRequestLocDR_LocDesc",node.text);
		           	setElement("MRRequestLocTel",node.DeptTel);
			        var Params=[{name:'Desc',type:'4',value:'MRLocationDR_LDesc'},{name:'LocDR',type:'2',value:node.id}]
		    		singlelookup("MRLocationDR_LDesc","PLAT.L.Locaton",Params)
		               
		       }
			}).loadData(jsonData.Building);
		});
	}
	else if(TreeFlag==0)
	{
		var paramsTo=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"MRRequestLocDR_LocDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"notUseFlag","type":"2","value":""}]; //,{name:'LocDR',type:'2',value:"MRRequestLocDR"}
        singlelookup("MRRequestLocDR_LocDesc","PLAT.L.Loc",paramsTo,"");
	} //modify by zyq 2023-03-17 3280807 end
	
	
}
/**
 * ����Ԫ�ؼ���
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initPage()
{
	initLookUp();		//��ʼ���Ŵ�
	defindTitleStyle();
	initButton();
	
	setRequiredElements("MREquipDR_EQName^MRRequestLocDR_LocDesc^MRExObjDR_ExObj^MRFaultCaseDR_FCDesc")  //modified by zx 2023-03-31 ά�޶�����Ϊ��
	if ((getElementValue("MRStatus")!="")&&(getElementValue("MRStatus")!=0))  //Modefied by zc 2022-11-22
	{	
		// Mozy0256		1221190		2020-3-13	��ʼ��ά�޷�ʽ������Ĭ�ϲ���Type
		var paramsFrom=[{"name":"MaintMode","type":"1","value":"MRMaintModeDR_MMDesc"},{"name":"Type","type":"2","value":"3"}];
    	singlelookup("MRMaintModeDR_MMDesc","EM.L.MaintMode",paramsFrom,"");
		if (jQuery("#MRMaintFee").length>0)
		{
			jQuery("#MRMaintFee").change(function(){totalFee_Change()});
		}
		if (jQuery("#MROtherFee").length>0)
		{
			jQuery("#MROtherFee").change(function(){totalFee_Change()});
		}
	}
	//add by wy 2023-4-12 3450423����Ȩ�޹���,ά����������
	var PParams=[{name:'VGroupType',type:'2',value:curGroupID},{name:'VEquipTypeDR',type:'4',value:'MREquipTypeDR'}]
    singlelookup("MRMaintGroupDR_MGDesc","EM.L.MaintGroup",PParams)
	//add by wy 2023-2-21 3319091��ʼ����������
	var PParams=[{name:'FaultCase',type:'4',value:'MRFaultCaseDR_FCDesc'},{name:'Equip',type:'2',value:getElementValue("MREquipDR")}]
	singlelookup("MRFaultCaseDR_FCDesc","EM.L.FaultCase",PParams)
	//add by wy 2023-3-6 3319090��ʼ����ŵص�
	var Params=[{name:'Desc',type:'4',value:'MRLocationDR_LDesc'},{name:'LocDR',type:'2',value:getElementValue("MRRequestLocDR")}]
	singlelookup("MRLocationDR_LDesc","PLAT.L.Locaton",Params)
	//add by wy 2023-3-6 3332138��ʼ��ά���˲�ѯ����
	var vParams=[{name:'MemberUser',type:'1',value:''},{name:'MGroupDR',type:'4',value:''},{name:'MFlag',type:'1',value:''},{name:'CurUserID',type:'3',value:''}]
	singlelookup("MRAcceptUserDR_UserNameFind","EM.L.MaintUser",vParams)
	initSeverityLevelFlagData(); //��ʼ�����ؿ��� add by zyq 2022-11-23
	initEmergencyFlagData(); //��ʼ���������� add by zyq 2022-11-23
	// MZY0156	3381014		2023-03-24
	if (jQuery("#BPrintEQEvent").length>0)
    {
        jQuery("#BPrintEQEvent").linkbutton({iconCls: 'icon-w-print'});
        jQuery("#BPrintEQEvent").on("click", BPrintEQEvent_Clicked);
    }
}
/**
 * �Ŵ�Ԫ��ѡ���ֵ����
 * @param {String} vElementID ����Ԫ��id
 * @param {Object} rowData �Ŵ�ѡ��������
 * @returns ��
 * @author zx 2022-08-11
 */
function setSelectValue(vElementID,rowData)
{
     //modified by WY 2022-9-8 ȥ��MRSourceType�ؼ���
	if (vElementID=="MRObjLocDR_LocDesc")
	{
		setElement("MRObjLocDR",rowData.TRowID)
		setElement("MRRequestTel",rowData.TTel)
	}
	else if (vElementID=="MRAssignDR_UserName"){setElement("MRAssignDR",rowData.TRowID)}		//20200318
	else if (vElementID=="MRRequestUserDR_UserName"){  //Modified By QW20211229 
		setElement("MRRequestUserDR",rowData.TRowID)
		setElement("MRRequestTel",rowData.TMobilePhone)
	}
	else if (vElementID=="MREquipStatusDR_ESDesc"){setElement("MREquipStatusDR",rowData.TRowID)}
	else if (vElementID=="MRMaintModeDR_MMDesc"){setElement("MRMaintModeDR",rowData.TRowID)}
	else if (vElementID=="MRServiceDR_SVName"){setElement("MRServiceDR",rowData.TRowID)}
	else if (vElementID=="MRFaultTypeDR_FTDesc"){setElement("MRFaultTypeDR",rowData.TRowID)}
	else if (vElementID=="MRFaultReasonDR_FRDesc"){setElement("MRFaultReasonDR",rowData.TRowID)}
	else if (vElementID=="MRDealMethodDR_DMDesc"){setElement("MRDealMethodDR",rowData.TRowID)}
	else if (vElementID=="MRMaintResultsDR_MRDesc"){setElement("MRMaintResultsDR",rowData.TRowID)}
	else if (vElementID=="MRMaintGroupDR_MGDesc"){setElement("MRMaintGroupDR",rowData.TRowID)}
	else if (vElementID=="MRChaMaintGroupDR_MGDesc"){setElement("MRMaintGroupDR",rowData.TRowID)}  //ת�鴦�� modify by zyq 2023-04-23 
	else if (vElementID=="MREmergencyLevelDR_ELDesc"){setElement("MREmergencyLevelDR",rowData.TRowID)}
	else if (vElementID=="MRSeverityLevelDR_SLDesc"){setElement("MRSeverityLevelDR",rowData.TRowID)}
	else if (vElementID=="MRFaultCaseDR_FCDesc"){setElement("MRFaultCaseDR",rowData.TRowID)}
	else if (vElementID=="MRAccessoryOriginalDR_AODesc"){setElement("MRAccessoryOriginalDR",rowData.TRowID)}  //Modify by zx BUG ZX0077
	else if (vElementID=="MRLocationDR_LDesc"){setElement("MRLocationDR",rowData.TRowID)}  //add by wy 2022-8-31 ����ص�
    else if (vElementID=="MREquipDR_EQName"){
	    setElement("MREquipDR",rowData.TRowID);
	    setElement("MREquipTypeDR",rowData.TEquipTypeDR);
	    setElement("MRExObjDR","");   //add by txr 20230423
	    if(getElementValue("MRMaintType")==1) createMaintHistory(rowData.TRowID);  //ά�޹���ʦ���޼�����ʷ��¼
	}
	else if (vElementID=="MRExObjDR_ExObj"){
	    setElement("MREquipDR",rowData.TRowID)
	    setElement("MREquipTypeDR",rowData.TEquipTypeDR)
	} 
	else if (vElementID=="UseLocDR_LocDesc")
	{
		setElement("UseLocDR",rowData.TRowID)
	}
	else if (vElementID=="MRAcceptUserDR_UserName")
	{
		setElement("MRAcceptUserDR",rowData.TUserdr)  //ά����
		setElement("MRMaintGroupDR_MGDesc",rowData.TMaintGroup)  //ά����
		setElement("MRMaintGroupDR",rowData.TMaintGroupDR)  //ά����
	}
	else if (vElementID=="MRAcceptUserDR_UserNameFind") //add by zyq 2022-11-21 begin
	{
		setElement("MRAcceptUserDRFind",rowData.TUserdr)  //ά���� ��ѯ
		setElement("MRMaintGroupDR_MGDescFind",rowData.TMaintGroup)  //ά����
		setElement("MRMaintGroupDRFind",rowData.TMaintGroupDR)  //ά����
	}//add by zyq 2022-11-21 end
	else if (vElementID=="MRAcceptUserDR_UserNameCha")  //ת�鴦��
	{
		setElement("MRAcceptUserDR",rowData.TUserdr)  //ά����
		setElement("MRChaMaintGroupDR_MGDesc",rowData.TMaintGroup)  //ά���� modify by zyq 2023-04-23
		setElement("MRMaintGroupDR",rowData.TMaintGroupDR)  //ά����
	}
	else if (vElementID=="MRReturnUserDR_UserName"){setElement("MRReturnUserDR",rowData.TRowID);}
	else if (vElementID=="MRUserSignDR_UserName"){setElement("MRUserSignDR",rowData.TRowID);}
	else if(vElementID=="MRRequestLocDR_LocDesc") //add by zyq 2023-03-17
	{
		setElement("MRRequestLocDR",rowData.TRowID);
		setElement("MRRequestLocTel",rowData.TTel);
	} 
}
/**
 * �Ŵ��������ʱidֵ���
 * @param {String} vElementID ����Ԫ��id
 * @returns ��
 * @author zx 2022-08-11
 */
function clearData(vElementID)
{
	var DRElementName=vElementID.split("_")[0]
	setElement(DRElementName,"")
        
	if (vElementID=="MRObjLocDR_LocDesc") 
	{
		setElement("MRRequestTel","")
		if (getElementValue("MRSourceType")==1){
		setElement("MRExObjDR_ExObj","");
		setElement("MRExObjDR","");
		clearData("MRExObjDR_ExObj")}
	}
	else if (vElementID=="MRAcceptUserDR_UserName")	
	{
		setElement("MRAcceptUserDR_Initials","");
	}
	else if (vElementID=="MRMaintGroupDR_MGDesc")	
	{
		setElement("MRAcceptUserDR_Initials","")
		setElement("MRAcceptUserDR_UserName","");
		setElement("MRAcceptUserDR","");
	}
	else if (vElementID=="MRAcceptUserDR_UserNameFind") //add by zyq 2023-02-15 begin
	{
		setElement("MRAcceptUserDRFind","")  
		setElement("MRMaintGroupDR_MGDescFind","") 
		setElement("MRMaintGroupDRFind","")  
	}//add by zyq 2023-02-15 end
}
/**
 * ��ť����
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function setEnabled()
{
	var Status=getElementValue("MRStatus");
	var curRole=getElementValue("RoleStep");
	var nextRole=getElementValue("NextFlowStep");
	var RowID=getElementValue("MRRowID");
	var ReadOnly=getElementValue("ReadOnly");
	if (ReadOnly=="Y")
	{
		disableElement("BSave",true)
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		//disableElement("BPicture",true)	// MZY0063	1580653		2020-12-11
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
		//Modefied by zc 2022-4-8 begin
		if (getElementValue("MRRetrieveFlag")==true)
		{
			hiddenObj("ReturnInfo",0)
		}
		//Modefied by zc 2022-4-8 end
	}
	if(RowID=="")
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BPicture",true)
	}
	if ((Status!=0)||((curRole!=0)&&(curRole!=nextRole)))
	{
		disableElement("BSubmit",true)
		disableElement("BDelete",true)
		disableElement("BSave",true)
	}
	
	if (Status>0)
	{
		disableElement("BSave",1);
		disableElement("BSubmit",1);
		disableAllElements();
	}
	else
	{
		disableElement("BSelfCancelSubmit",true);
		//disableAllElements("MRObjLocDR_LocDesc^MRSourceType^MRExObjDR_ExObj^MREquipStatusDR_ESDesc^MRFaultCaseDR_FCDesc^MRFaultCaseRemark^MRStartDate^MRRequestUserDR_UserName^MRRequestTel^MRLocationDR_LDesc^MRPackageState^MRAcceptUserDR_UserName^MRMaintModeDR_MMDesc^MRRequestLocTel^MRLocationDR_LDesc^MREquipDR_EQName^MRRequestLocDR_LocDesc^UseLocDR_LocDesc^EndDate^StartDate"); //modify by zyq 2022-11-15
	}
	if (Status!=2)
	{
		disableElement("BCancel",true);
		disableElement("BPrint",true);
		hiddenObj("BPrintEQEvent",1);	// MZY0156	3381014		2023-03-24
	} 
	//Moidefied by zc0066 2020-4-11  �����������Ӱ�ť�һ� begin
	if (ReadOnly=="1")
	{
		disableElement("BCancel",true)
		disableElement("BPrint",true)
	}
	if (Status=="2")
	{
		disableElement("BSelfCancelSubmit",true)   // add by mwz 2021-01-18 MWZ0048
	}
	//Moidefied by zc0066 2020-4-11  �����������Ӱ�ť�һ� end
}
/**
 * ��ʼ��ʱ��ͬ״̬��Ԫ��ֵ����
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function setElementEnabled()
{
	var Status=getElementValue("MRStatus");
	var RoleStep=getElementValue("RoleStep");
	var Action=getElementValue("ActionCode");
	var MaintType=getElementValue("MRMaintType")
	if (Status>0)	//�ύ֮��
	{
		//���ݶ����ж���ʾ����
		var Action=getElementValue("ActionCode");
		if ((Action=="WX_Assign")||(Action=="WX_Accept"))
		{
			if (Action=="WX_Assign")
			{
				setElement("MRAssignDR_UserName",curUserName);
				setElement("MRAssignDR",curUserID);
				setElement("MRAssignDate",getElementValue("CurDate"));
				disableElement("SeverityLevelFlag",false);
				disableElement("EmergencyLevelFlag",false);
				disableElement("MRMaintGroupDR_MGDesc",false);
				disableElement("MRAcceptUserDR_UserName",false);
			}
			
			disableElement("MRAssignDR_UserName",true);
			disableElement("MRAssignDate",true);
			//��ʱ��Ч
			//disableElement("BMaintDetail",true);
			//disableElement("BMaintUser",true);
			$("#MaintDiv").remove();
			$("#ReturnDiv").remove();
			$("#LocAuditDiv").remove();
		}
		else if(Action=="WX_Return")
		{
			setElement("MRReturnUserDR_UserName",curUserName);
			setElement("MRReturnUserDR",curUserID);
			setElement("MRReturnDate",getElementValue("CurDate"));
			$("#LocAuditDiv").remove();
			$("#ActionChoose").find("div").empty(); //add by wy 2023-3-3
		}
		else if(Action=="WX_LocAudit")
		{
			$("#ActionChoose").find("div").empty();
			setElement("MRUserSignDR_UserName",curUserName);
			setElement("MRUserSignDR",curUserID);
			setElement("MRCheckDate",getElementValue("CurDate"));
			var result=tkMakeServerCall("web.DHCEQMoveNew","CheckMoveReturn","31",getElementValue("MRRowID"));   //add by wy 2022-11-30
			if (result==0){
			$("#ReturnDiv").remove();}

		}
		else if((Action=="WX_Appearance")||(Action=="WX_Maint")||(Action=="WX_Finish"))
		{
			if(Action!="WX_Appearance")
			{
				$("#ActionChoose").find("div").empty();
			}
			else
			{
				$("#FromActinCode").val("WX_Appearance,WX_Maint");
				$("#ToActionCode").val("WX_Finish");
				initEditFields(getElementValue("ApproveSetDR"),"",getElementValue("ToActionCode"));
			}
			if (Action=="WX_Maint")
			{
				$("#ActionChoose").find("div").empty();
				//initEditFields(getElementValue("ApproveSetDR"),"",getElementValue("ActionCode"));
			}
			else if (Action=="WX_Finish")
			{
				$("#ActionChoose").find("div").empty();
				disableElement("MRReplaceFlag",false); //add by zyq 2023-03-22 3197351
				//initEditFields(getElementValue("ApproveSetDR"),"",getElementValue("ActionCode"));
			}
			
			setElement("MRRetrieveUserDR_UserName",curUserName);
			setElement("MRRetrieveUserDR",curUserID);
			setElement("MRRetrieveDate",getElementValue("CurDate"));
			
			$("#ReturnDiv").remove();
			$("#LocAuditDiv").remove();
		}
		else if (Action=="WX_Retrieve")
		{
			$('#retrievePanel').removeClass('eq-hidden');
			$('#finishPanel').addClass('eq-hidden');
			$("#ActionChoose").find("div").empty();
			setElement("MRRetrieveUserDR_UserName",curUserName);
			setElement("MRRetrieveUserDR",curUserID);
			setElement("MRRetrieveDate",getElementValue("CurDate"));
			$("#ReturnDiv").remove();
			$("#LocAuditDiv").remove();
		}
		else if(Action=="WX_ManageLocAudit") //add by zyq 2022-12-07 
		{
			setElement("MRUserSignDR_UserName",curUserName);
			setElement("MRCheckDate",getElementValue("CurDate"));
			$("#ActionChoose").find("div").empty(); //add by wy 2023-4-11 �������û��ȡ�ص��������ʾ�黹��Ϣ
			var result=tkMakeServerCall("web.DHCEQMoveNew","CheckMoveReturn","31",getElementValue("MRRowID"));  
			if (result==0){
			$("#ReturnDiv").remove();}

		}
		else
		{
			$("#ActionChoose").find("div").empty();
		}
	}
	else
	{
		if (MaintType!="1")
		{
			setElement("MRAssignDR_UserName","");
			setElement("MRAssignDR","");
			setElement("MRAssignDate","");
		}
	}

}

/**
 * ����ά�޷Ѻ�����ѻ����ܷ���
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function totalFee_Change()
{
	var MaintFee=getElementValue("MRMaintFee")
	if (MaintFee=="") MaintFee=0
	MaintFee=parseFloat(MaintFee);
	var OtherFee=getElementValue("MROtherFee")
	if (OtherFee=="") OtherFee=0
	OtherFee=parseFloat(OtherFee);
	var tmpValue=(MaintFee.toFixed(2)*1)+(OtherFee.toFixed(2)*1);
	tmpValue=parseFloat(tmpValue);
	setElement("MRTotalFee",tmpValue.toFixed(2))
}
/**
 * ��ȡ������¼�뷽ʽ 0:�Ŵ� 1:�ֹ�¼��,���Զ������·����� 2:
 * @param {String} type ¼�뷽ʽ
 * @param {String} ElementID ������id
 * @param {String} ElementName ����������
 * @returns {String} ServiceRowID ������id
 * @author zx 2022-08-11
 */
function getServiceRowID(type,ElementID,ElementName)
{
	if((type=="0")||(type==""))
	{
		 var ServiceRowID=getElementValue(ElementID)  //modified by wy 2022-9-28 2955208
	}
	else
	{
		var ServiceRowID=""
		var ServiceName=getElementValue(ElementName);
		if (ServiceName=="") return "";
		var FirmType=4
	 	var val="^"+ServiceName+"^^^"+FirmType;		//2163109 czf
		var ServiceRowID=tkMakeServerCall("web.DHCEQForTrak","UpdProvider",val);
		if (ServiceRowID>0) setElement(ElementID,ServiceRowID);
	}
	return ServiceRowID
}
/**
 * ��ȡ�ն�����
 * @param ��
 * @returns ��
 * @author zx 2022-08-11
 */
function getTermType()
{
	return "";
}
/**
 * ���������뵱ǰʱ���
 * @param {string} date ���� 'yyyy-mm-dd'
 * @return {string} ������
 * @author zx 2022-08-11
 */
function daysBetween(date, time)
{
	var result="";
	if (time=="") time="00:00:00";
    //��ȡʱ��ʼ
    var diff='';
    var beginDate = new Date(date + ' ' + time);
	var endDate = new Date(getCurrentDate() + ' ' + getCurrentTime());
    var timeDiff = endDate.getTime() - beginDate.getTime();
	
    var days = Math.floor(timeDiff / (24 * 3600 * 1000));
	
    var residue = timeDiff % (24 * 3600 * 1000);
    var hours = Math.ceil(residue / 3600 / 1000);
	
	result = days + '��'+ hours + 'Сʱ';
	
    return result
}
/**
 * ��ȡ��ǰ���� ��ʽ��yyyy-MM-dd
 * @param ��
 * @returns {String} currentdate ����
 * @author zx 2022-08-11
 */
function getCurrentDate()
{
	var date = new Date();
	var seperator1 = "-";
	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	if (month >= 1 && month <= 9) {
	    month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
	    strDate = "0" + strDate;
	}
	var currentdate = year + seperator1 + month + seperator1 + strDate;
	return currentdate;
}
/**
 * ��ȡ��ǰ���� ��ʽ��hh:mm:ss
 * @param ��
 * @returns {String} t ʱ��
 * @author zx 2022-08-11
 */
function getCurrentTime() {
	var time = new Date();
	var h = time.getHours();
	var min = time.getMinutes()
	var s = time.getSeconds();
	var t = (h<10?('0'+h):h)+':'+(min<10?('0'+min):min)+':'+(s<10?('0'+s):s);
	return t;
}
/**
 * ��ӡ������ʱδ����
 * @param {String} ��
 * @returns {String} ��
 * @author zx 2022-08-11
 */
function BPrint_Clicked()
{
	//modified by ZY20230215 bug:3267279
	var RowID=getElementValue("MRRowID")
	if (RowID=="") return
	printCardLodop(RowID)
	return
	var PreviewRptFlag=getElementValue("PreviewRptFlag");
	var fileName=""	
	var HOSPDESC = getElementValue("GetHospitalDesc");
	//Add By QW20210913 BUG:QW0147 �������Ӳ�����	begin
	var EQTitle="";
	var PrintNumFlag=getElementValue("PrintNumFlag");
	if(PrintNumFlag==1)  
	{
		var num=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","GetOperateTimes","31",RowID)
		if(num>0) EQTitle="(����)";
	}
	if(PreviewRptFlag==1)
	{
		var fileName="DHCEQMMaintRequestPrint.raq&RowID="+RowID
			+"&HOSPDESC="+HOSPDESC
			+"&USERNAME="+curUserName+"&EQTitle="+EQTitle
			DHCCPM_RQPrint(fileName);
	}
	if(PreviewRptFlag==0)
	{
		var fileName="{DHCEQMMaintRequestPrint.raq(RowID="+RowID
			+";HOSPDESC="+HOSPDESC
			+";USERNAME="+curUserName
			+";EQTitle="+EQTitle+")}"; 
			DHCCPM_RQDirectPrint(fileName);
	}	
	var MaintRequestPrintOperateInfo="^31^"+RowID+"^^ά�޴�ӡ����^0"
	var PrintFlag=tkMakeServerCall("web.DHCEQ.Plat.BUSOperateLog","SaveData",MaintRequestPrintOperateInfo)
	//Modified By QW20210913 BUG:QW0147 �޸Ĵ�ӡ����  end
}
//modified by ZY20230215 bug:3267279  Lodop��ӡ
function printCardLodop(RowID)
{
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQMMaintRequest");
	var LODOP = getLodop();
	var c2=String.fromCharCode(2);
	var inpara="MRObjLocDR_LocDesc"+c2+ObjData.MRObjLocDR_LocDesc;
	inpara+="^MRRequestNo"+c2+ObjData.MRRequestNo;
	inpara+="^MRRequestDate"+c2+ObjData.MRRequestDate;
	inpara+="^MRExObjDR_ExObj"+c2+ObjData.MRExObjDR_ExObj;
	inpara+="^EQNo"+c2+ObjData.MRExObjDR_EQNo;
	inpara+="^EQModel"+c2+ObjData.MRExObjDR_EQModel;
	///modified by ZY20230414 bug:3431216
	inpara+="^EQStartDate"+c2+ObjData.MRExObjDR_EQStartDate;
	inpara+="^MRStartDate"+c2+ObjData.MRStartDate;
	inpara+="^MRFaultCaseDR_FCDesc"+c2+ObjData.MRFaultCaseDR_FCDesc+" "+ObjData.MRFaultReasonRemark;
	inpara+="^MRMaintModeDR_MMDesc"+c2+ObjData.MRMaintModeDR_MMDesc;
	inpara+="^ApproveOpinon1"+c2+ObjData.ApproveOpinon1;
	inpara+="^ApproveOpinon2"+c2+ObjData.ApproveOpinon2;
	inpara+="^ApproveOpinon3"+c2+ObjData.ApproveOpinon3;
	inpara+="^MRMaintResultsDR_MRDesc"+c2+ObjData.MRMaintResultsDR_MRDesc+" "+ObjData.MRDealMethodDR_DMDesc;
	inpara+="^MRSaveCostFee"+c2+ObjData.MRSaveCostFee;
	inpara+="^MRTotalFee"+c2+ObjData.MRTotalFee;
	inpara+="^MRRequestUser"+c2+ObjData.MRRequestUserDR_UserName;
	inpara+="^PrintDate"+c2+GetCurrentDate(2);
	
	var jsonArr=[
			{type:"img",name:"ApproveUser1",x:"115.788", y:"95.503",width:"20",height:"6",value:ObjData.ApproveUser1},
			{type:"img",name:"ApproveUser2",x:"115.788", y:"105.503",width:"20",height:"6",value:ObjData.ApproveUser2},
			{type:"img",name:"ApproveUser3",x:"115.788", y:"115.503",width:"20",height:"6",value:ObjData.ApproveUser3}
		]
	
	DHC_PrintByLodop(LODOP,inpara,"",jsonArr,"",{printListByText:true});
}
/**
 * �������������������
 * @param {String} ��
 * @returns {String} ��
 * @author zx 2022-08-11
 */
function initApproveList()
{
	var rowId=getElementValue("MRRowID");
	if (rowId=="") return
	$cm({
		ClassName:"web.DHCEQ.Plat.LIBMessages",
		QueryName:"GetApproveList",
		BussType:"31",
		SourceID:rowId
	},function(rs){
		reverseData(rs.rows)
		
	});
}

/**
 * �������ݴ����������
 * @param {Arrary} ������Ϣ��������
 * @returns ��
 * @author zx 2022-08-11
 */
function reverseData(data)
{
    var detailData = [];
    for (var i = 0; i < data.length; i++) {
	    var offApprove=true;
    	var lastApproveFlag=false;
        if (data[i].TApproveDate) {
	        offApprove=false;
	        if(i+1<data.length){
		        //Modify by zx ������һ����,���ֳ�ʱ����ѡ������ֵ
		        if(!data[i+1].TApproveDate){
			        lastApproveFlag=true;
			        if((getElementValue("ActionCode")=="WX_Appearance")&&(data[i+1].TActionCode!="WX_Appearance")){
				        var panelBtnKey={"WX_Finish":"finish","WX_Maint":"maint","WX_BeRetrieved":"toRetrieve","WX_Retrieve":"retrieve","WX_Accept":"changeGroup","WX_Assign":"cancel"};
				        panelBtnClick(panelBtnKey[data[i].TActionCode]);
				    }
			    }
		    }
        }
        detailData.push({
            'actionDesc': data[i].TAction,
            'dateInfo': data[i].TApproveDate + " " + data[i].TApproveTime,
            'otherInfo': data[i].TApproveRole + " " + data[i].TApproveUser + " " + data[i].TOpinion,
            'offApprove':offApprove,
            'lastApproveFlag':lastApproveFlag
        })
    }
    var detailHtml = createTimeLineNew(detailData);
    $("#detailtimeline").append(detailHtml);
}
/**
 * ͼƬ��Ϣ�鿴
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BPicture_Clicked()
{
	var Status=getElementValue("MRStatus");
	var str='dhceq.plat.picturemenu.csp?&CurrentSourceType=31&CurrentSourceID='+getElementValue("MRRowID")+'&Status='+Status;
	if ((Status==2)||(getElementValue("ReadOnly")=="Y")) str=str+"&ReadOnly=1";		// MZY0063	1580653		2020-12-11
	var title="ͼƬ��Ϣ"
	var width=""
	var height=""
	var icon="icon-w-edit"
	var showtype=""
	showWindow(str,title,width,height,icon,showtype,"","","middle"); //modify by lmm 2020-06-05 UI
}
/**
 * �������Ӱ�ť�¼�
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BAdd_Clicked()
{
        var url='dhceq.em.equipAdddevice.csp?RowID=';
        showWindow(url,"ά�޶���","420px","369px","icon-w-paper","modal","","","small")     //modify by lmm 2020-06-01 UI //modify by txr 2023-02-10 UI //modify by zyq 2023-03-28
        
}
/**
 * ����ʱ��ʼ������ά������
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function initMaintWaitListDataGrid()
{
 	///Modified By QW20200707 BUG:QW0069 end 
 	//Modefied  by WY 2023-2-25 ���³�ʼ��ά���б����� 3266883 begin
    var vData=GetLnk()
    var Columns=getCurColumnsInfo('EM.G.Queue.MaintRequest','','','')
	var ClassName="web.DHCEQ.Plat.LIBMessages"
	var QueryName="GetBussDataByCode"
	var QType=getElementValue("QXType")
	var maintType=getElementValue("MRMaintType");
	if ((QType==0)&&(maintType==0))
	{
		 ClassName="web.DHCEQ.EM.BUSMMaintRequest"
		 QueryName="GetMaintRequestDetail"
		 Columns=getCurColumnsInfo('EM.G.MaintRequest.OperateList','','','')
	}
	$HUI.datagrid("#tMaintWaitList",{
	url:$URL,
	queryParams:{
		    	ClassName:ClassName,
	        	QueryName:QueryName,
				BussType:'31',
				GroupID:'',
				UserID:'',
				CurLocDR:'',
				EquipDR:'',
				DatePattern:getElementValue("DatePattern"), //
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				LocPattern:getElementValue("LocPattern"), //
				UseLocDR:getElementValue("UseLocDR"),
				UserPattern:getElementValue("UserPattern"), //
				UserDR:getElementValue("MRAcceptUserDRFind"), //modify by zyq 2022-11-21
				vActionDR:getElementValue("ActionDR"),
				vData:vData
		},
		toolbar:[{
    			iconCls: 'icon-add',
                text:'�ߵ�',  
                id:'add',        
                handler: function(){
                     BReminder_Clicked();
                }},{
    			iconCls: 'icon-cancel',  //Modefied  by WY 2023-3-1 3319089 begin
                text:'����',  
				id:'cancel',        
                handler: function(){
                     BatchCancel_Clicked();
                }} ],
		border:false,  //add by zx 2019-06-14 ��ʽ�ı�,ȥ���߿� Bug ZX0067
	    fit:true,
	    //singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:Columns,
		pagination:true,
		pageSize:100,
		pageNumber:1,
		pageList:[7,14,21,28,35,100], //modify by zyq
		onLoadSuccess: function (data) {
			var QType=getElementValue("QXType")	
			if 	(QType==2)
			{
				hiddenObj("add",1)
				hiddenObj("cancel",1)  //Modefied  by WY 2023-3-1 3319089 end
			}	
		}

	});
	//$('#tMaintWaitList').datagrid('showColumn','TCheck');
}
/**
 * ����ʱ����ά�����ݲ�ѯ�¼�
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BFind_Clicked()
{
	var vData=GetLnk()
	//Modefied  by WY 2023-2-25 ά���б����ݲ�ѯ 3266883
	var ClassName="web.DHCEQ.Plat.LIBMessages"
	var QueryName="GetBussDataByCode"
	var QType=getElementValue("QXType")
	var maintType=getElementValue("MRMaintType");
	if ((QType==0)&&(maintType==0))
	{
		 ClassName="web.DHCEQ.EM.BUSMMaintRequest"
		 QueryName="GetMaintRequestDetail"
	}
	$HUI.datagrid("#tMaintWaitList",{
		url:$URL,
		queryParams:{
		    	ClassName:ClassName,
	        	QueryName:QueryName,
				BussType:'31',
				GroupID:'',
				UserID:'',
				CurLocDR:'',
				EquipDR:'',
				DatePattern:getElementValue("DatePattern"), //
				StartDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
				LocPattern:getElementValue("LocPattern"), //
				UseLocDR:getElementValue("UseLocDR"),
				UserPattern:getElementValue("UserPattern"), //
				UserDR:getElementValue("MRAcceptUserDRFind"), //modify by zyq 2022-11-21
				vActionDR:getElementValue("ActionDR"),
				vData:vData
		}})
	jQuery('#tMaintWaitList').datagrid('unselectAll') 
}
/**
 * ����ʱ����ά�����ݲ�ѯ����
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function GetLnk()
{
	var lnk="";
	//lnk=lnk+"^ActionPattern="+getElementValue("ActionPattern");
	lnk=lnk+"^MREquipTypeDR="+getElementValue("MREquipTypeDR");  
	lnk=lnk+"^EmergencyFlag="+getElementValue("EmergencyFlag");
	lnk=lnk+"^ReminderFlag="+getElementValue("ReminderFlag");
	lnk=lnk+"^ManageTypeID="+getElementValue("MRManageTypeDR"); //add by zyq 2023-02-24
	lnk=lnk+"^EquipTypeFindDR="+getElementValue("MREquipTypeFindDR"); //add by zyq 2023-03-07
	lnk=lnk+"^KeyWord="+getElementValue("KeyWord"); //add by 2023-3-1 �ؼ��ֲ�ѯ3266967
	return lnk
}
/**
 * �ߵ������¼�
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BReminder_Clicked()
{
	var checkedItems = $('#tMaintWaitList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TBussID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','��ʾ',"δѡ��ά�޵���")
		return false;
	}
	var length=selectItems.length;
	var str=""
	var InfoStr=""
	for(i=0;i<selectItems.length;i++)//��ʼѭ��
	{
		if (str=="")
		{
			str=selectItems[i];//ѭ����ֵ	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","ReminderBuss",'31',str,curUserID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','��ʾ',"�ߵ�ʧ��!"+jsonData.Data)
	}
	else
	{
		messageShow('popover','success','��ʾ','�ߵ��ɹ���','','','');
		jQuery('#tMaintWaitList').datagrid('unselectAll') 
		jQuery('#tMaintWaitList').datagrid('reload') 
	}
}
/**
 * ��Ϊָ������ʱѡ����
 * @param {String} vType 1Ϊ�˻� 2Ϊ ���
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function dataGridSelect(vType,vRowData)
{
	if (vType==0)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserApprove(vDataStr)
	}
	if (vType==1)
	{
		var vDataStr=vRowData.TRowID+"^"+vRowData.TRoleDR+"^"+vRowData.TRole+"^"+vRowData.TStep+"^"+vRowData.TAction
		getUserCancelApprove(vDataStr)
	}
}
/**
 * ��Ϊָ������ʱ���ѡ������
 * @param {String} Value ��һ��approveflowid
 * @returns ��
 * @author zx 2022-08-11
 */
function getUserApprove(Value)
{
	var list=Value.split("^");
	var ApproveFlowID=list[0];
	setElement("ApproveFlowID",ApproveFlowID);
	approveEquipStop();
}
/**
 * ��Ϊָ������ʱȡ�������
 * @param {String} Value ��һ��approveflowid
 * @returns ��
 * @author zx 2022-08-11
 */
function getUserCancelApprove(Value)
{
	var list=Value.split("^");
	setElement("CancelToFlowDR",list[0]);
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
    if (RtnObj.SQLCODE<0)
    {
	    messageShow("","","",RtnObj.Data)
    }
    else
    {
	    messageShow("","","",t[0])
		websys_showModal("options").mth("31");
		var url="dhceq.em.maintrequest.csp?&RowID="+RtnObj.Data+"&CurRole="+getElementValue("CurRole");
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50);
    }
}
/**
 * ������������
 * @param {String} ��
 * @returns ��
 * @author wy 2023-3-1
 */
function BatchCancel_Clicked()
{	
    //add by wy 2023-4-13 3450427����������ʾ
	messageShow("confirm","info","��ʾ","�Ƿ����ϵ���","",DoCancel,function(){
		return;
	});		
}
 function DoCancel()
{
	var checkedItems = $('#tMaintWaitList').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TBussID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','��ʾ',"δѡ��ά�޵���")
		return false;
	}
	var length=selectItems.length;
	var str=""
	var InfoStr=""
	for(i=0;i<selectItems.length;i++)//��ʼѭ��
	{
		if (str=="")
		{
			str=selectItems[i];//ѭ����ֵ	
		}
		else
		{
			str=str+","+selectItems[i]
		}
	}
	selectItems.splice(0,selectItems.length);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.LIBMessages","CancellBuss",'31',str,curUserID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
	{
		messageShow('alert','error','��ʾ',"����ʧ��!"+jsonData.Data)
	}
	else
	{
		messageShow('popover','success','��ʾ','���ϳɹ���','','','');
		jQuery('#tMaintWaitList').datagrid('unselectAll') 
		jQuery('#tMaintWaitList').datagrid('reload') 
	}

	
}

/**
 * �������ϰ�ť,������ʱû�д���
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BCancel_Clicked()
{
    var RowID=getElementValue("MRRowID")
    if (RowID=="")  {messageShow("","","",t[-9205]);    return; }
    messageShow("confirm","info","��ʾ",t[-9206],"",bcanceltrue,"")
}
function bcanceltrue()
{
    var RowID=getElementValue("MRRowID")
    var Ret=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","CancelMaintRequest",RowID)
    var RetObj=jQuery.parseJSON(Ret)
    if (RetObj.SQLCODE<0)
    {
        messageShow("","","",RetObj.Data)
        return;
    }
    else if(RetObj.SQLCODE==0) //modify by zyq 2023-04-22 begin
    {
	    messageShow("","","","���ϳɹ�");
	}
	else
	{
		 messageShow("","","",RetObj.Data); //modify by zyq 2023-04-22 end
	}
    websys_showModal("options").mth("31");  //modify by zx 2022-04-11 bug ZX0144
    //Modeied by zc0094 2021-1-14 ����ά�޵�����ҳ������ begin
    window.setTimeout(function()
    {   
        if (getElementValue("MRMaintType")!="1")
        {
            var url="dhceq.em.hardwaremaintsimple.csp?&RowID=&Status=0";
            if ('function'==typeof websys_getMWToken){      //czf 2023-02-14 token���ò�������
                url += "&MWToken="+websys_getMWToken()
            }
            if ((getElementValue("MRManageTypeDR")=="4")&&(getElementValue("QXType")==1)) //Modified BY QW20211229
            {
                window.location.href= url
            }
            else{
                window.location.href= url
            }
        }
        else
        {
            var url="dhceq.em.maintrequest.csp?&RowID=&Status=0&MaintType=1";
            if ('function'==typeof websys_getMWToken){      //czf 2023-02-14 token���ò�������
                url += "&MWToken="+websys_getMWToken()
            }
            window.location.href= url
        }
    },50); 
    //Modeied by zc0094 2021-1-14 ����ά�޵�����ҳ������ end
}
function confirmselect(confirminfo)
{
    return messageShow("confirm","info","��ʾ",confirminfo,"",selecttrue,selectfalse)
}

/**
 * ˢ�´����б�
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function refreshMaintTable()
{
	$('#tMaintWaitList').datagrid('reload');	
}
/**
 * ����ά����ʷ��¼��ά��֪ʶ��
 * @param {String} equipId �豸id
 * @returns ��
 * @author zx 2022-08-11
 */
function createMaintHistory(equipId)
{
	if (equipId=="") return
	$("#Banner").attr("src",'dhceq.plat.banner.csp?&EquipDR='+equipId);
	var MaintHistory=tkMakeServerCall("web.DHCEQ.EM.BUSMMaintRequest","GetMaintHistory",equipId);
	var MaintHistoryObj=jQuery.parseJSON(MaintHistory)
	if (MaintHistoryObj.SQLCODE<0) return
	var MaxKey=""
	for (var key in MaintHistoryObj.Data){MaxKey=key}
	for (var key in MaintHistoryObj.Data)
	{
		var RowID="MaintHistoryID"+key
		var OntMaintInfo=MaintHistoryObj.Data[key]
		var RequestDate=OntMaintInfo["RequestDate"]
		var RequestUser=OntMaintInfo["RequestUser"]
		var FaultCaseDR=OntMaintInfo["FaultCaseDR"]
		var FaultCase=OntMaintInfo["FaultCase"]
		var FaultReasonDR=OntMaintInfo["FaultReasonDR"]
		var FaultReason=OntMaintInfo["FaultReason"]
		var DealMethodDR=OntMaintInfo["DealMethodDR"]
		var DealMethod=OntMaintInfo["DealMethod"]
		var AcceptUser=OntMaintInfo["AcceptUser"]
		//��ʷά�޼�¼
		var flag=""
		if (key==MaxKey) flag=1
		var options={id:'tMaintHistorytree',section:'',item:'^^'+RequestDate+'%eq-user.png^^'+AcceptUser+'%eq-faultcase.png^^'+FaultCase,lastFlag:flag}
		createTimeLine(options)
		//֪ʶ��
		if (FaultCaseDR!="")
		{
			var KnowledgeF="Knowledge_"+FaultCaseDR
			var FaultCaseObj=appendTree("tKnowledgetree","Knowledge_"+FaultCaseDR,FaultCase,"")
			if ((FaultCaseObj!=null)&&(FaultReasonDR!=""))
			{
				var KnowledgeR=KnowledgeF+"_"+FaultReasonDR
				var FaultReasonObj=appendTree("tKnowledgetree",KnowledgeR,FaultReason,KnowledgeF)
				if ((FaultReasonObj!=null)&&(DealMethodDR!=""))
				{
					var KnowledgeD=KnowledgeR+"_"+DealMethodDR
					appendTree("tKnowledgetree",KnowledgeD,DealMethod,KnowledgeR)
				}
			}
			//$("#tKnowledge").find("span").removeClass("tree-folder tree-file")
		}
	}
}
/**
 * ά�����
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function BMaintDetail_Click()
{
	var rowID=getElementValue("MRRowID");
	if (rowID=="")
	{
		messageShow("","","",t[-9205]);
		return;
	}
	var status=2;
	if(getElementValue("CurRole")=="19") status=1;  //ά�޹���ʦ
    var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQMMaintPart&MaintRequestDR='+rowID+'&MaintItemDR=&Status='+status;
    showWindow(str,"ά�����","","","icon-w-paper","","","","middle",maintPartCall);
}
/**
 * ά���������ص�����
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function maintPartCall(otherFee)
{
	$("#MROtherFee").val(otherFee);
	totalFee_Change();
}

//add by zyq 2022-11-23
//��ʼ�����صȼ�����
function initSeverityLevelFlagData()
{	
	$HUI.switchbox('#SeverityLevelFlag',{
        onText:'һ��',
        offText:'����',
        onClass:'info',
        offClass:'primary',
        onSwitchChange:function(e,obj){
            if ($(this).switchbox('getValue'))
            {	
            	setElement("MRSeverityLevelDR","");	
            }
            else
            {
	            setElement("MRSeverityLevelDR",2);
	        }
           
        },
        onInit:function(){
	    }
    })
   	if(getElementValue("MRSeverityLevelDR")==2)  
	{
		$("#SeverityLevelFlag").switchbox("setValue",false);
	}
}
//add by zyq 2022-11-23
//��ʼ�������ȼ�����
function initEmergencyFlagData()
{
        //modified by wy 2023-4-3 3417821
	$HUI.switchbox('#EmergencyLevelFlag',{
        onText:'һ��',
        offText:'����',
        onClass:'info',
        offClass:'primary',
        onSwitchChange:function(e,obj){
            if ($(this).switchbox('getValue'))
            {	
            	setElement("MREmergencyLevelDR","");
            }
            else
            {
	            setElement("MREmergencyLevelDR",2);
	        }
           
        },
        onInit:function(){

	    }
    })
   if(getElementValue("MREmergencyLevelDR")==2)  
	{
		$("#EmergencyLevelFlag").switchbox("setValue",false);
	}
}
/**
 * ���ֳ�ʱ���������Ҫ������ѡ��ť��ֵ
 * @param {String} ��
 * @returns ��
 * @author zx 2022-08-11
 */
function chooseActionBtn(actionCode)
{
	//console.log(actionCode)
}
// MZY0156	3381014		2023-03-24
function BPrintEQEvent_Clicked()
{
	var RowID=getElementValue("MREquipDR");
	if (RowID=="") return;

	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	var curSSHospitalName=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990003");
	var c2=String.fromCharCode(2);
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCEQEvent");
	var LODOP = getLodop();
    var inpara="EvtTitle"+c2+curSSHospitalName+"����ҽ���豸�����¼������";
    inpara+="^EQNo"+c2+jsonData.Data.EQNo;
    inpara+="^EQName"+c2+jsonData.Data.EQItemDR_MIDesc;
	inpara+="^EQCommonName"+c2+jsonData.Data.EQName;
    inpara+="^EQModel"+c2+jsonData.Data.EQModelDR_MDesc;
    inpara+="^EQRegistrationNo"+c2+jsonData.Data.EQRegistrationNo;
    inpara+="^EQLeaveFactoryNo"+c2+jsonData.Data.EQLeaveFactoryNo;
	inpara+="^EQManuFactory"+c2+jsonData.Data.EQManuFactoryDR_MFName;
	inpara+="^EQMFAdress"+c2+jsonData.Data.EQMFAdress;
	inpara+="^EQMFTel"+c2+jsonData.Data.EQMFTel;
	DHC_PrintByLodop(LODOP,inpara,"","","",{printListByText:true});
}
