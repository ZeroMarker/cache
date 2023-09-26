		var isSet=false
		var win=top.frames['eprmenu'];
		if (win)
		{
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
 
				isSet=true;
			}
		}
		if (isSet==false)
		{
			var frm =dhcsys_getmenuform();
			if (frm) { 				
			var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
					}
		}
//var EpisodeID=dhccl.getUrlParam("EpisodeID");
var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
$(function(){

    initConditionFormControls();
    setDefaultValueControls();
    initOperationGrid();
    
});

//��ʼ�����ؼ�
function initConditionFormControls(){
	$HUI.datebox("#DateFrom",{
	})
	$HUI.datebox("#DateTo",{
	})
    var appLoc=$HUI.combobox("#AppLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID="";
        },
        mode:'remote'
    });
    var patWard=$HUI.combobox("#PatWard",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=GetWard&ResultSetType=array",
        valueField:"rw",
        textField:"desc",
        onBeforeLoad:function(param)
        {
            param.code=param.q;
        },
        mode:'remote'
    });
    var operStat=$HUI.combobox("#OperStat",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=LookUpComCode&ResultSetType=array",
        valueField:"tCode",
        textField:"tDesc",
        onBeforeLoad:function(param)
        {
            param.type="OpaStatus";
        }
    });
    var OperType=$HUI.combobox("#OperType",{
        valueField:"typecode",
        textField:"typedesc",
        panelHeight:'auto',
        data:[{'typedesc':"ȫ��",'typecode':"A"},{'typedesc':"����",'typecode':"B"},{'typedesc':"����",'typecode':"E"}]
    })

    var operRoom=$HUI.combobox("#OperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
        panelHeight:'auto',
        onBeforeLoad:function(param)
        {
            param.oprDesc=param.q;
            param.locDescOrId="";
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID=EpisodeID;
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId=appLoc.getValue();
        }
    });
    $("#btnSearch").click(function(){
        $HUI.datagrid("#OperListBox").load();
    }); 
}
//��ʼ�������б�
var lastselctrowindex="";
function initOperationGrid(){
    var lastscr="",lastccr="",lastscrDesc="",lastccrDesc="",lastanmdr="",lastanmdrDesc;
    var operList=$HUI.datagrid("#OperListBox",{
        fit:true,
        selectOnCheck:false,
        checkOnSelect:false,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        checkbox: true,
        //title:'�����б���',
        headerCls:'panel-header-gray',
        toolbar:"#OperListTool",
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetAnOpList"
        },
        onBeforeLoad:function(param)
        {
            param.stdate=$("#DateFrom").datebox('getValue');
            param.enddate=$("#DateTo").datebox('getValue');
            param.stat=$("#OperStat").combobox('getValue');
            param.oproom=($("#OperRoom").combobox('getText')=="")?"":$("#OperRoom").combobox('getValue');
            param.Dept=$("#AppLoc").combobox('getValue');
            param.appType="";
            param.userLocId=logLocId;
            param.IsAppT=$("#IsAppDate").checkbox('getValue')?"1":"0";
            param.MedCareNo=$("#MedCareNo").val();
            param.operType=$("#OperType").combobox('getValue');
            param.patWardId=$("#PatWard").combobox('getValue');
            param.paidType=$("#chkPaidOp").checkbox('getValue')?"Y":"N";
            param.LogUserType=getLogUserType();
            param.ifAllLoc=$("#IfAllLoc").checkbox('getValue')?"Y":"N";
            param.ifOutOper=$("#IsOutOper").checkbox('getValue')?"O":"I";
            var mulStr="";
			mulStr=($("#chkIsDayOper").checkbox('getValue')?"Y":"N")+"|"+($("#chkIsNeedAN").checkbox('getValue')?"Y":"N");
            param.mulStr=mulStr;
        },
        onCheck:function(rowIndex, rowData) {
	         //20190927+dyl
	        $('#OperListBox').datagrid('selectRow',rowIndex);
	        var selectRows=$("#OperListBox").datagrid("getChecked");
		    if(selectRows.length==1)
		    {
		       
				var win=top.frames['eprmenu'];
				if (win)
				{
					var EpisodeID = rowData["adm"];
					var PatientID=rowData["PatientID"];
					var mradm=rowData["PAADMMainMRADMDR"];
					var AnaesthesiaID=rowData["AnaesthesiaID"];
					var frm = win.document.forms['fEPRMENU'];
					if (frm)
					{
						frm.EpisodeID.value=EpisodeID; 
						frm.PatientID.value=PatientID; 
						frm.mradm.value=mradm; 
		 				if (frm.AnaesthesiaID)
								frm.AnaesthesiaID.value = AnaesthesiaID;
						isSet=true;
					}
				}
				if (isSet==false)
				{
					var EpisodeID = rowData["adm"];
					var PatientID=rowData["PatientID"];
					var mradm=rowData["PAADMMainMRADMDR"];
					var AnaesthesiaID=rowData["AnaesthesiaID"];
					var frm =dhcsys_getmenuform();
					if (frm) { 				
						frm.EpisodeID.value=EpisodeID; 
						frm.PatientID.value=PatientID; 
						frm.mradm.value=mradm; 
						if (frm.AnaesthesiaID)
								frm.AnaesthesiaID.value = AnaesthesiaID;
							}
				}
		//
		    }
        },
        onUncheck:function(rowIndex, rowData) {
	        //20190927+dyl
	        $('#OperListBox').datagrid('unselectRow',rowIndex);
	        var selectRows=$("#OperListBox").datagrid("getChecked");
		    if(selectRows.length==1)
		    {
				var EpisodeID = selectRows[0].adm;
				var PatientID=selectRows[0].PatientID;
				var mradm=selectRows[0].PAADMMainMRADMDR;
				var AnaesthesiaID=selectRows[0].AnaesthesiaID;
				var win=top.frames['eprmenu'];
				if (win)
				{
					var frm = win.document.forms['fEPRMENU'];
					if (frm)
					{
						frm.EpisodeID.value=EpisodeID; 
						frm.PatientID.value=PatientID; 
						frm.mradm.value=mradm; 
		 				if (frm.AnaesthesiaID)
								frm.AnaesthesiaID.value = AnaesthesiaID;
						isSet=true;
					}
				}
				if (isSet==false)
				{
					
					var frm =dhcsys_getmenuform();
					if (frm) { 				
						frm.EpisodeID.value=EpisodeID; 
						frm.PatientID.value=PatientID; 
						frm.mradm.value=mradm; 
						if (frm.AnaesthesiaID)
								frm.AnaesthesiaID.value = AnaesthesiaID;
							}
				}
		//
		    }

        },
        onClickRow: function(rowIndex, rowData) {
	       
	        if(lastselctrowindex!="")
	        {
		        $('#OperListBox').datagrid('uncheckRow',lastselctrowindex);
	        }
			opaId = rowData["opaId"];
			 lastscr=rowData["scrubNurseDr"];
			 lastscrDesc=rowData["scrubnurse"];
			 lastccr=rowData["circleNurseDr"];
			 lastccrDesc=rowData["circulnurse"];
			 lastanmdr=rowData["anmetDr"];	//20190125+dyl
			 lastanmdrDesc=rowData["anmethod"];
			$('#OperListBox').datagrid('clearSelections');
			$('#OperListBox').datagrid('selectRow',rowIndex);
			$('#OperListBox').datagrid('checkRow',rowIndex);
		var isSet=false
		var win=top.frames['eprmenu'];
		if (win)
		{
			var EpisodeID = rowData["adm"];
			var PatientID=rowData["PatientID"];
			var mradm=rowData["PAADMMainMRADMDR"];
			var AnaesthesiaID=rowData["AnaesthesiaID"];
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				frm.EpisodeID.value=EpisodeID; 
				frm.PatientID.value=PatientID; 
				frm.mradm.value=mradm; 
 				if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
				isSet=true;
			}
		}
		if (isSet==false)
		{
			var EpisodeID = rowData["adm"];
			var PatientID=rowData["PatientID"];
			var mradm=rowData["PAADMMainMRADMDR"];
			var AnaesthesiaID=rowData["AnaesthesiaID"];
			var frm =dhcsys_getmenuform();
			if (frm) { 				
				frm.EpisodeID.value=EpisodeID; 
				frm.PatientID.value=PatientID; 
				frm.mradm.value=mradm; 
				if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
					}
		}
		lastselctrowindex=rowIndex;
		},
        columns: [
            [
                { field: "oproom", title: "����", width: 80 ,
					editor:{
						type:'combobox',
						options:{
							panelWidth:120,
							valueField:'oprId',
							textField:'oprDesc',
							data:getOpRoomList()	
						}
					},
					formatter:function(value,row){
						if((/^(\+|-)?\d+$/.test( value )))
						{
						var oproomList=getOpRoomList();
						for(var i=0;i<oproomList.length;i++)
						{
							if(oproomList[i].oprId==value)
							{
								return oproomList[i].oprDesc;
							}
						}
						}else{
							return value;
						}
					}
				},
                { field: "opordno", title: "̨��", width: 50 ,
                	editor:{
						type:'combobox',
						options:{
							panelWidth:80,
							valueField:'code',
							textField:'desc',
							data:getOrdNo()	
						}
					}
                },
                { field: "opSeqNote", title: "����̨��", width: 65 },
                { field: "loc", title: "����", width: 140 },
                { field: "scrubnurse", title: "��е��ʿ", width: 120 ,
					editor:{
						type:'combobox',
						options:{
							multiple:true,
							rowStyle:'checkbox',
							selectOnNavigation:false,
							panelWidth:120,
							valueField:'ctcpId',
							textField:'ctcpDesc',
							data:getOPNurseList()
							,onShowPanel:function(){
								//alert(lastscrDesc)
								if((lastscr!="")&&(lastscrDesc!=""))
								{
								 	lastIdStr=getIdStr(lastscr);
									var ed = $('#OperListBox').datagrid('getEditor', {index:editIndex,field:'scrubnurse'});
									$(ed.target).combobox('setValues',lastIdStr); 
								}
							}
						}
					}
					
				},
                { field: "circulnurse", title: "Ѳ�ػ�ʿ", width: 120 ,
					editor:{
						type:'combobox',
						options:{
							multiple:true,
							rowStyle:'checkbox',
							selectOnNavigation:false,
							panelWidth:120,
							valueField:'ctcpId',
							textField:'ctcpDesc',
							data:getOPNurseList()
							,onShowPanel:function(){
								if((lastccr!="")&&(lastccrDesc!=""))
								{
								 	lastcIdStr=getIdStr(lastccr);
									var ed = $('#OperListBox').datagrid('getEditor', {index:editIndex,field:'circulnurse'});
									$(ed.target).combobox('setValues',lastcIdStr); 
								}
							}	
						}
					}
                },
                { field: "regno", title: "�ǼǺ�", width: 95 },
                { field: "patname", title: "����", width: 70 },
                { field: "sex", title: "�Ա�", width: 40 },
                { field: "age", title: "����", width: 45 },
                { field: "diag", title: "��ǰ���", width: 180 },
                { field: "opname", title: "��������", width: 280 },
                { field: "bodsDesc", title: "��λ", width: 80 },
                { field: "andoc", title: "����ҽ��", width: 80,
					editor:{
						type:'combobox',
						options:{
							panelWidth:120,
							valueField:'ctcpId',
							textField:'ctcpDesc',
							data:getANDoctorList()	
						}
					},
					formatter:function(value,row){
						if((/^(\+|-)?\d+$/.test( value )))
						{
						var andocList=getANDoctorList();
						for(var ia=0;ia<andocList.length;ia++)
						{
							if(andocList[ia].ctcpId==value)
							{
								return andocList[ia].ctcpDesc;
							}
						}
						}else{
							return value;
						}
					}
				},

                { field: "anmethod", title: "����ʽ", width: 120 ,
						editor:{
						type:'combobox',
						options:{
							multiple:true,
							rowStyle:'checkbox',
							selectOnNavigation:false,
							panelWidth:200,
							valueField:'ID',
							textField:'Des',
							data:getAnaMethodList()
							,onShowPanel:function(){
								//20190125+dyl
								if((lastanmdr!="")&&(lastanmdrDesc!=""))
								{
								 	var lastanmIdStr=getIdStr(lastanmdr);
									var ed = $('#OperListBox').datagrid('getEditor', {index:editIndex,field:'anmethod'});
									$(ed.target).combobox('setValues',lastanmIdStr); 
								}
							}	
						}
					}

					
					},
                { field: "bloodType", title: "Ѫ��", width: 40 },
                { field: "yy", title: "��Ⱦ", width: 80 },
                { field: "Isolated", title: "����", width: 40 },
                { field: "opdoc", title: "����ҽ��", width: 160 },
                { field: "opDocNote", title: "���߱�ע", width: 65 },
                { field: "opmem", title: "����Ҫ��", width: 80 },
                { field: "opdate", title: "��ʼʱ��", width: 120 },
                { field: "jzstat", title: "����", width: 40 },
                { field: "dayOperFlag", title: "�ռ�", width: 40 },
                { field: "OpAppDateStr", title: "��������ʱ��", width: 100 },
                { field: "adm", title: "�����", width: 60 },
                { field: "ico", title: "Flag", width: 60 },
                { field: "oppack", title: "������", width: 100 },
                { field: "isAddInstrument", title: "�Ƿ񲹳���е", width: 100 },
                { field: "instrument", title: "��е", width: 40 },
                { field: "AnaesthesiaID", title: "AnaesthesiaID", width: 120 },
                { field: "patWard", title: "����", width: 60 },
                { field: "medCareNo", title: "������", width: 60 },
                { field: "oprFloor", title: "����¥��", width: 65 },
                { field: "opdatestr", title: "����ʱ��", width: 125 },
                { field: "estiOperDuration", title: "Ԥ����ʱ", width: 65 },
                { field: "preDiscussDate", title: "��ǰ��������", width: 60 },
                { field: "isExCirculation", title: "����ѭ��", width: 60 },
                { field: "anCompDesc", title: "�ϲ�����", width: 60 },
                { field: "isUseSelfBlood", title: "�Ƿ�����Ѫ����", width: 60 },
                { field: "operPosition", title: "��λ", width: 60 },
                { field: "OPCategory", title: "��������", width: 60 },
                { field: "operInstrument", title: "������е", width: 60 },
                { field: "NeedAnaesthetist", title: "�������", width: 60 },
                { field: "opsttime", title: "������ʼʱ��", width: 60 },
                { field: "retReason", title: "�ܾ�ԭ��", width: 60 },
                { field: "opNurseOrd", title: "������ʿ�շ�״̬", width: 60 },
                { field: "anaDoctorOrd", title: "����ʦ�շ�״̬", width: 60 },
                { field: "anaNurseOrd", title: "����ʿ�շ�״̬", width: 60 },
                { field: "tPacuBed", title: "�ָ���λ", width: 60 ,
									editor:{
											type:'combobox',
											options:{
												panelWidth:120,
												valueField:'oprId',
												textField:'PacuBedDesc',
												data:getPACUBedList()	
											}
										},
									formatter:function(value,row){
										if((/^(\+|-)?\d+$/.test( value )))
										{
										var pacuList=getPACUBedList();
										for(var ip=0;ip<pacuList.length;ip++)
										{
											if(pacuList[ip].oprId==value)
											{
												return pacuList[ip].PacuBedDesc;
											}
										}
										}else{
											return value;
										}
									}
										},
                { field: "PACUInDateTime", title: "��ָ���ʱ��", width: 60 },
                { field: "anDocAss", title: "��������", width: 60 },
                { field: "anNurse", title: "����ʿ", width: 60 },
                { field: "topaAnSheetPrintAudit", title: "������ӡ���", width: 60 },
                { field: "topaAnSheetEditAudit", title: "�����޸����", width: 60 },
                { field: "ASA", title: "ASA�ȼ�", width: 60 },
                { field: "opUnPlanedOperation", title: "�ط�����", width: 60 },
                { field: "selfReport", title: "����(������)", width: 60 },
                { field: "operStock", title: "����Ԥ���Ĳ�", width: 60 },
                { field: "operStockNote", title: "����Ԥ���Ĳı�ע", width: 60 },
                { field: "appDocDesc", title: "����ҽ��", width: 60 },
                { field: "transferFlag", title: "����", width: 60 
	                ,align:'center'
	                ,editable: true
					,formatter: function(value,metadata,record){
						var EpisodeID =record.adm;
						var url="dhcanopertransferlist.view.csp?&dateFrm="+$("#DateFrom").datebox('getValue')+"&dateTo="+$("#DateTo").datebox('getValue')+"&EpisodeID="+EpisodeID+"!"+"dialogWidth:1150px;dialogHeight:760px;status:no;menubar:no;";
						if(value==1){
							return '<img title="����" src="../scripts/dhccl/img/recevice.png" onclick="ClickIcoHandler('+'\''+url+'\''+')" />';
						}
						else if(value==2){
							return '<img title="����" src="../scripts/dhccl/img/send.png" onclick="ClickIcoHandler('+'\''+url+'\''+')"/>';
						}
						else
						{
							return ""
						}
					
				}
                },
                { field: "scNurNote", title: "��е��ע", width: 100 },
                { field: "cirNurNote", title: "Ѳ�ر�ע", width: 100 },
                { field: "anDocNote", title: "����ҽ����ע", width: 100 },
                { field: "opaId", title: "opaId", width: 40 },
                { field: "PatientID", title: "PatientID", width: 40 },
                { field: "scrubNurseDr", title: "scrubNurseDr", hidden: true },
                { field: "circleNurseDr", title: "circleNurseDr", hidden: true },
                { field: "anmetDr", title: "anmetDr", hidden: true },
                { field: "PAADMMainMRADMDR", title: "PAADMMainMRADMDR", width: 40 },
                { field: "secretCode", title: "��������", width: 60 },
                { field: "patLevel", title: "���߼���", width: 60 }
            ]                
        ],
        frozenColumns:[[
        { field: "check",checkbox:true },
        { field: "status", title: "״̬", width: 50 
        ,styler:function(value,row,index){
	       var result=""
	       switch (row.status)
	       { 
	       	case '����':
                    if(row.jzstat=='����') result='BACKGROUND-COLOR: #FFB8BE;';
                    break;
	      	case '�ܾ�':
                    result='BACKGROUND-COLOR: #10B5F5;'; //blue /refuse
                    break;
                case '����':
                    result='BACKGROUND-COLOR: #94E290;';  //green //arranged
                    break;
                case '���':
                    result='BACKGROUND-COLOR: #F9FFBC; ' ;//yellow //finish
                    break;
                case '����':
                    result='BACKGROUND-COLOR: #FF0008;' ;//red 
                    break;
                case '����':
                    result='BACKGROUND-COLOR: #BEEDE3;' ;//light blue
                    break;
                case '�ָ���':
                    result='BACKGROUND-COLOR: #FFD0FF;';
                    break;
                case '����':
                    result= 'BACKGROUND-COLOR: #A0A0A0;';
                    break;
                default:
                    result= 'BACKGROUND-COLOR: #F2FFFF;'; 
                    break; 
            }
            return result;
	       }
        }]],
        onSelect:function(index,data){
            //$("#patient-toolbar").find(".content").html(data.patname+" / "+data.sex+" / "+data.age+" / "+data.regno);
        },
		handler:function(){ //���ܸı��ֵ
        $("#OperListBox").datagrid('acceptChanges');
        },
		onBeforeEdit:function(rowIndex,rowData){
			var logLocType=getLogLocType();
			if((logLocType!="OP")&&(logLocType!="AN"))
			{
				return false;
			}
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			 var opaId=rowData.opaId;
			 var opDate=rowData.opdatestr.split(' ')[0].trim();
			 //console.log(changes);
			 if(changes.oproom&&changes.oproom!=undefined)
			 {
				var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateOpRoomAndOrdNo",
					opaId:opaId,
					roomId:changes.oproom,
					maxNo:maxOrdNo,
					opDate:opDate
				},false);
				if((/^(\+|-)?\d+$/.test( result ))&&result>0) 
				{	
					var noproomList=getOpRoomList();
					var showroomdr=changes.oproom;
					var newroom=changes.oproom;
						for(var ri=0;ri<noproomList.length;ri++)
						{
							var newoproomdr=noproomList[ri].oprId
							if(newoproomdr==showroomdr)
							{
								newroom=noproomList[ri].oprDesc;
							}
						}

					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							opordno:result,
							status:'����',
							oproom:newroom
						}
						});
					
				}else{
					alert(result);
					$("#OperListBox").datagrid('reload');	
				}
			 }
			 if(changes.opordno&&changes.opordno!=undefined){
				 var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateOpaSeqNo",
					opaId:opaId,
					opaSeqNo:changes.opordno,
					opDate:opDate
				},false);
				if(result==0) 
				{	
					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							status:'����',
							opordno:changes.opordno
						}
					});
					
				}else{
					alert(result);
					$("#OperListBox").datagrid('reload');	
				}
			 }
			 //alert(changes.scrubnurse)
			 if(changes.scrubnurse!=undefined){
				 //alert(changes.scrubnurse)
				 var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateAnArrForNurse",
					opDate:opDate,
					opaIdStr:opaId,
					nurStr:changes.scrubnurse,
					nurType:"D"
				},false);
				if(result=="")
				{
					//20181213+dyl
					var curScrubNurseIdStr=rowData.scrubnurse;
					var curScrubNurseIdList=curScrubNurseIdStr.split(",");
					var newtestvalue=""
					for(var i2=0;i2<curScrubNurseIdList.length;i2++)
					{
						curScrubNurseId=curScrubNurseIdList[i2];
						var curNurseList=getOPNurseList();
						for(var i3=0;i3<curNurseList.length;i3++)
						{
							if(curNurseList[i3].ctcpId==curScrubNurseId)
							{
								if(newtestvalue!="") newtestvalue=newtestvalue+","+curNurseList[i3].ctcpDesc;
								
								else{
									newtestvalue=curNurseList[i3].ctcpDesc
								}
							}
						}
					}
					//	
					var ret1=$.m({
						ClassName:"web.DHCANOPArrange",
						MethodName:"UpdateAllAnOpArr",
						opDate:opDate,
						opaIdStr:opaId,
						nurType:"D"
					},false);
					if(ret1!="")  
					{
						alert(ret1);
                	}					
                	else{
	                	$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							scrubnurse:newtestvalue,
							scrubNurseDr:curScrubNurseIdStr
							
						}
					});
					 $('#OperListBox').datagrid('unselectRow',rowIndex); 
                	}

				}
				
			 }	
			 if(changes.circulnurse!=undefined){
				 var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateAnArrForNurse",
					opDate:opDate,
					opaIdStr:opaId,
					nurStr:changes.circulnurse,
					nurType:"T"
				},false);
				if(result=="")
				{
				 	var ret1=$.m({
						ClassName:"web.DHCANOPArrange",
						MethodName:"UpdateAllAnOpArr",
						opDate:opDate,
						opaIdStr:opaId,
						nurType:"T"
					},false);
					if(ret1!="")  
					{
					alert(ret1);
                	}
                	else
                	{
	                //20181213+dyl
					var curCirNurseIdStr=rowData.circulnurse;
					var curCirNurseIdList=curCirNurseIdStr.split(",");
					var newccvalue=""
					for(var i3=0;i3<curCirNurseIdList.length;i3++)
					{
						curCirNurseId=curCirNurseIdList[i3];
						var curCNurseList=getOPNurseList();
						for(var i4=0;i4<curCNurseList.length;i4++)
						{
							if(curCNurseList[i4].ctcpId==curCirNurseId)
							{
								if(newccvalue!="") newccvalue=newccvalue+","+curCNurseList[i4].ctcpDesc;
								
								else{
									newccvalue=curCNurseList[i4].ctcpDesc
								}
							}
						}
						}
					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							circulnurse:newccvalue,
							circleNurseDr:curCirNurseIdStr
						}
					});
					 $('#OperListBox').datagrid('unselectRow',rowIndex); 
					
                	}
				}
			 }	
			 if(changes.tPacuBed&&changes.tPacuBed!=undefined)
			 {
				var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdatePacuBed",
					opaId:opaId,
					PacuBedId:changes.tPacuBed,
				},false);
				if(result==0) 
				{	
					
					var pacubedList=getPACUBedList();
					var showpacudr=changes.tPacuBed;
					var newpacu=changes.tPacuBed;
						for(var lp=0;lp<pacubedList.length;lp++)
						{
							var newerpacudr=pacubedList[lp].oprId;
							if(newerpacudr==showpacudr)
							{
								newpacu=pacubedList[lp].PacuBedDesc;
							}
						}
					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							tPacuBed:newpacu
						}
						});
					
					
				}else{
					alert(result);
					$("#OperListBox").datagrid('reload');	
				}
			 }
			 if(changes.andoc&&changes.andoc!=undefined)
			 {
				var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateAnArrDocAndMethod",
					opaId:opaId,
					docId:changes.andoc,
					anmId:""
				},false);
				if(result==0) 
				{	
					var andocList=getANDoctorList();
					var showandocdr=changes.andoc;
					var newandoc=changes.andoc;
						for(var la=0;la<andocList.length;la++)
						{
							var newerandocr=andocList[la].ctcpId
							if(newerandocr==showandocdr)
							{
								newandoc=andocList[la].ctcpDesc;
							}
						}
					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							andoc:newandoc
						}
						});
					//$("#OperListBox").datagrid('reload');
				}else{
					alert(result);
					$("#OperListBox").datagrid('reload');	
				}
			 }
			 if(changes.anmethod&&changes.anmethod!=undefined)
			 {
				var result=$.m({
					ClassName:"web.DHCANOPArrange",
					MethodName:"UpdateAnArrDocAndMethod",
					opaId:opaId,
					docId:"",
					anmId:changes.anmethod
				},false);
				if(result==0) 
				{	
				//20190125+dyl
									//20181213+dyl
					var curanmIdStr=rowData.anmethod;
					var curanmIdList=curanmIdStr.split(",");
					var newanmvalue=""
					for(var im=0;im<curanmIdList.length;im++)
					{
						curanmId=curanmIdList[im];
						var curAnMList=getAnaMethodList();
						for(var im3=0;im3<curAnMList.length;im3++)
						{
							if(curAnMList[im3].ID==curanmId)
							{
								if(newanmvalue!="") newanmvalue=newanmvalue+","+curAnMList[im3].Des;
								
								else{
									newanmvalue=curAnMList[im3].Des
								}
							}
						}
					}

				//
					$("#OperListBox").datagrid('updateRow',{
						index:rowIndex,
						row:{
							anmethod:newanmvalue,
							anmetDr:curanmIdStr
						}
						});
					//$("#OperListBox").datagrid('reload');
				}else{
					alert(result);
					$("#OperListBox").datagrid('reload');	
				}
			 } 
			 $('#OperListBox').datagrid('uncheckAll');  
		},
		onClickCell:onClickCell
    });
	var groupId=getNewGroupIdbyAudit();
    setLogUserTypeMenus(groupId);
    setLogUserTypeButtons(groupId);
}
var maxOrdNo=30;
var editIndex = undefined;
function endEditing(){
			if (editIndex == undefined){return true}
			if ($("#OperListBox").datagrid('validateRow', editIndex)){
				$("#OperListBox").datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
}
function onClickCell(index, field){
	$("#OperListBox").datagrid('selectRow',index);
	var selectRowObj=$("#OperListBox").datagrid('getSelected');
	var seldylindex=$("#OperListBox").datagrid('getRowIndex',selectRowObj);
	if(index!=seldylindex)
	{
		$("#OperListBox").datagrid("unselectRow",seldylindex);
		$("#OperListBox").datagrid("selectRow",index);
		selectRowObj=$("#OperListBox").datagrid('getSelected');
	}
	var logLocType=getLogLocType();
	if (endEditing()){
		var flag=false;
		var canEditCloumns=$.m({
			ClassName:"web.DHCANOPArrange",
			MethodName:"getEditColumn",
			groupId:logGroupId
		},false);
		if(canEditCloumns.split("^").length<1) return false;
		for(var i=0;i<canEditCloumns.split("^").length;i++)
		{
			if(field==canEditCloumns.split("^")[i])
			{
				flag=true
				break;
			}
		}
		if(!flag) return false;
		var statusn=selectRowObj.status;
		/*
		var opaIdnew=selectRowObj.opaId;
		var testrow=$("#OperListBox").datagrid('getChecked');
		var rowData="";
		if(testrow&&testrow.length>0)
    	{
	        for(var ir=0;ir<testrow.length;ir++)
	        {
	            rowData=testrow[ir];
	            var curopaId=rowData.opaId;
	            if(curopaId==opaIdnew) 
	            {
		            var curindecsel=$("#OperListBox").datagrid('getRowIndex',rowData);
		            $("#OperListBox").datagrid("uncheckRow",curindecsel);
		            continue;
	            }
	            else
	            {
					statusn=rowData.status;
	            }
	        }
    	}
    	*/
		if ((field=='tPacuBed')&& (statusn != '����')) {
			$.messager.alert("��ʾ","ֻ�ܲ�������״̬�Ĳ���!","error");
			return false;
		}
		//alert(index)
		if((field == 'oproom')&&(statusn != '����') && (statusn != '����'))
		{
			$.messager.alert("��ʾ","ֻ�ܲ���״̬Ϊ���Ż����������!","error");
			return false;
		}
		if (field == 'opordno') {
			var value = selectRowObj.oproom;
			if (value == '��') {
				$.messager.alert("��ʾ","�����Ȱ���������!","error");
				return false;
			}
			if(statusn!='����') 
			{ 
				$.messager.alert("��ʾ","ֻ�ܲ�������״̬����!","error");
				return false;
			}
		}
		if(field=='scrubnurse')   
		{
			if(statusn!='����') 
			{ 
				$.messager.alert("��ʾ","ֻ�ܲ�������״̬����!","error");
				return false;
			}
		}
		if(field=='circulnurse')   
		{
			if(statusn!='����') 
			{ 
				$.messager.alert("��ʾ","ֻ�ܲ�������״̬����!","error");
				return false;
			}
		}
		if((field=='anmethod')||(field=='andoc'))  
		{
			if(statusn!='����') 
			{ 
				$.messager.alert("��ʾ","ֻ�ܲ�������״̬����!","error");
				return false;
			}
			if(logLocType!="AN")
			{return false;}
		}
		
		$("#OperListBox").datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
			editIndex = index;
	}
}	

//ȡ�µİ�ȫ��id   
function getNewGroupIdbyAudit()
{
	var newGroupId=$.m({
		ClassName:"web.DHCANAduitAccredit",
		MethodName:"GetNewGroupIdbyAudit",
		ctlocId:logLocId,
		userId:logUserId,
		groupId:logGroupId
	},false)
	return newGroupId
}			
//��¼��ȫ����ز˵�
function setLogUserTypeMenus(groupId){
    var menus=$.cm({
        ClassName:"web.DHCANOPArrange",
        QueryName:"GetGroupConfig",
        typeCode:"MENU",
        groupId:groupId,
        ResultSetType:"array"
    },false);
    if(menus&&menus.length>0)
    {
        menus.sort(up);
        for(var i=0;i<menus.length;i++)
        {
            $("#menu-toolbar").menu('appendItem',{
                id:menus[i].name,
                text:menus[i].caption,
                onclick:OnMenuClick
            });
        }
    }
}
//��¼��ȫ����ذ�ť
function setLogUserTypeButtons(groupId){
    var buttons=$.cm({
        ClassName:"web.DHCANOPArrange",
        QueryName:"GetGroupConfig",
        typeCode:"BUTTON",
        groupId:groupId,
        ResultSetType:"array"
    },false);
    if(buttons&&buttons.length>0)
    {
        buttons.sort(up);
        for(var i=0;i<buttons.length;i++)
        {
            var btn='<a href="javascript:void(0)" id="'+buttons[i].name+'" ></a>'
            $("#botton-toolbar").append(btn);
            if(buttons[i].name=="CheckRiskAssessment")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-check-reg',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="btnCancelOper")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-cancel',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="btnAnDocOrdered")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-write-order',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="btnClearRoom")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-reset',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="CheckSafetyInfo")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-apply-check',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="btnOPNurseOrdered")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-write-order',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="OPControlledCost")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-add-note',
                plain: 'true'
            });
        	}
        	else if(buttons[i].name=="btnDirAudit")
            {
            $("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-star-light-yellow',
                plain: 'true'
            });
        	}
        	else
        	{
	        	$("#botton-toolbar").find("#"+buttons[i].name).linkbutton({
                text:buttons[i].caption,
                iconCls:'icon-buttonshow',
                plain: 'true'
            });
        	}
            $("#botton-toolbar").find("#"+buttons[i].name).bind('click',OnButtonClick);
        }
    }
}
function up(x,y)
{
    return x.rowId-y.rowId;
}

function OnMenuClick(){
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=UDHCANOPAPP"
    var nwin="toolbar=no;location:no;directories:no;status:no;menubar:no;scrollbars:yes;resizable:no;dialogHeight:700px;dialogWidth:960px;top:0;left:0"
    switch(this.id)
    {  
        case "AppOper":
            AppNewOper('ward',lnk,nwin,"In");
            break;
          case "applyGridTest":
           applyGridTest('ward',lnk,nwin,"In");
            break;
        case "AppOperClinics":	 //������������  add  by lyn  20160410
            //AppNewOper('ward',lnk,nwin,"Out");
            MZSSApply('ward',lnk,nwin,"Out");
            break;
        case "AppIntervent":	 //������������  add  by lyn  20160410
            AppNewOper('ward',lnk,nwin,"Inter");
            break;
        case "AlterOper":
            ManageOper('ward',lnk,nwin,"In");
            break;
        case "UpdateOperClinics":  //�����޸���������
            MZSSAlter('ward',lnk,nwin,"Out");
            break;
        case "ArrOper":				
            HISUIManageOper('op',lnk,nwin,"In");
            break;  
        case "ArrOperClinics":  //������������ add  by lyn  20160410
            //ManageOper('op',lnk,nwin,"Out");  
            MZSSAlter('op',lnk,nwin,"Out");
            break;	
        case "RefuseOper":
            RefuseOper();
            break;
        case "CancelRef":
            CancelRefusedOper();
            break;
        case "ArrAn":
            //ManageOper('anaes',lnk,nwin,"In");  
            HISUIManageOper('anaes',lnk,nwin,"In");   
            break;
        case "MonAn":
            AnAtOperation("AN");
            break;
        case "AnConsent":
            AnAtOperation("AC");
            break;
        case "PreOpAssessment":
            AnAtOperation("AMT");
            break;
        case "PostOpRecord":
            AnAtOperation("PAV");
            break;
        case "AnRecord":
            AnAtOperation("ANI");
            break;
        case "PACURecord":
            AnAtOperation("PACU");
            break;	
        case "AnPdfDisplay":
            AnPdfDisplay();
            break;
        case "ANOPCount":
            ANOPCount();
            break;
        case "RegOper":
            HISUIManageOper('RegOp',lnk,nwin,"In");
            break;
        case "RegOperClinics": //��������Ǽ� add  by lyn  20160410
           // ManageOper('RegOp',lnk,nwin,"Out");
           MZSSAlter('RegOp',lnk,nwin,"Out");
            break;
        case "PrintMZSSYYD":
            PrintMZSSYYD("MZSSYYD","N");
            break;
        case "PrintSSYYDBNZ":  //add by lyn 20160410  �����Ͽ���
            var closeWindow = confirm("�Ƿ񵼳���(ȡ����ֱ�Ӵ�ӡ)");
            if(closeWindow) PrintAnOpList("SSYYDBNZ","Y");
            else PrintAnOpList("SSYYDBNZ","N");
            break;
        case "PrintSSYYDTY":  //add by lyn 20160517  �ۿ�
            var closeWindow = confirm("�Ƿ񵼳���(ȡ����ֱ�Ӵ�ӡ)");
            if(closeWindow) PrintAnOpList("SSYYDTY","Y");
            else PrintAnOpList("SSYYDTY","N");
            PrintAnOpList("SSYYDTY","N");
            break;
        case "PrintSQD":
            PrintAnOpList("SQD","N");
            break;
        case "PrintSSD":
            PrintAnOpList("SSD","N");
            break;
        case "PrintMZD":
            PrintAnOpList("MZD","N");
            break;
        case "CancelOper":
            CancelOper();
            break;
        case "AdverseEvent":
            DHCCLMSAN();
            break;
        case "OperTransfer":     //����ת������ add by YuanLin 20170815
            OperTransfer();
            break;
        case "AduitAccredit":
            ManageAduitAccredit();
            break;
        case "AlterDayOper":
                AlterDayOper('ward',lnk,nwin,"In");
                break;
       case "ConfirmDayOper":
                ConfirmDayOper('ward',lnk,nwin,"In");
                break;
	  case "ANAuditDayOper":	//�ռ���ǰ����
            btnANAuditOper();
            break;
	  case "ANPostDayOperAcess":	//�ռ���������
            btnANPostAcess();
            break;
      case "ANDayOutAcess":	//�ռ��Ժ����
            btnANDayOutAcess();
            break; 
       case "DHCANOPNurseRecord":	//��������
       		DHCANOPNurseRecord();
       		break;
       case 'MaterialListTotal':	//20191029+dyl+�����嵥ͳ��
       		MaterialListTotal();
       		break;

        default:
            break;
    }
}
function OnButtonClick(){
    switch(this.id)
    {
        case 'btnClearRoom':
            btnClearRoom_click();
            break;
        case 'btnOpRoomLimit': //�й�ҽ����
            btnOpRoomLimit_click();
            break;
        case 'btnOpRoomOpen': //�й�ҽ����
            btnOpRoomOpen_click();
            break;
        case 'btnDirAudit':
            btnDirAudit_click();
            break;
        case 'btnAnDocOrdered':
            btnAnDocOrdered_click();
            break;
        case 'btnArrAnDocAuto':
            btnArrAnDocAuto_click();	//20181213+dyl
            break;
        case 'btnArrNurseAuto':
        	btnArrNurseAuto_click();	//20190125+dyl
            break;
        case 'btnOPNurseOrdered':	//20161214+dyl
            btnOPNurseOrdered_click();
            break;
        case 'btnInRoom':
            btnInRoom_click();
            break;
        case 'btnLeave':
            btnLeave_click();
            break;
        case 'btnCancelOper': //������������ͬ�ھܾ�����
            btnCancelOper_click();
            break;
        case 'CheckRiskAssessment': //������������������ҽ��
            CheckRiskAssessment();
            break;
        case 'CheckSafetyInfo':	//������ȫ�˲飺����ҽ��
            CheckSafetyInfo();
            break;
        case "OPControlledCost":		//�ɿسɱ�
            OPControlledCost();
            break;
        case "ANEquip":	//�����豸����
            ANEquip();
            break; 
		 case "InRoomCheck":  //���Һ˲�
           	ReceivePat("InRoom");
           	break;
        case "OutRoomCheck":  //���Һ˲�
           	ReceivePat("OutRoom");
           	break;
		case "OperAssess":  //��������
           	OperAssess();
           	break;
    case "RegMaterialList":  //���������嵥20191028+dyl
           	RegMaterialList();
           	break;
       
        default:
            break;
    }
}
//���ؼ�����Ĭ��ֵ
function setDefaultValueControls(){
    var dateFrom=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDate",
        userId:logUserId,
        userGroupId:logGroupId, 
        ctlocId:logLocId
    },false);
    var dateTo=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDateOld",
        userId:logUserId,
        userGroupId:logGroupId, 
        ctlocId:logLocId
    },false);
    $("#DateFrom").datebox('setValue',dateFrom);
    $("#DateTo").datebox('setValue',dateTo);

    var doctorLoc=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"GetDocLoc",
        userId:logUserId,
        ctlocId:logLocId
    },false)
    var ifCanAppOper=$.m({
            ClassName:"web.DHCClinicCom",
            MethodName:"CheckIfAppLoc",
            ctlocId:logLocId
        },false);
    

    if((doctorLoc&&doctorLoc!="")&&(ifCanAppOper==1))
    {
        var doctorLocStr=doctorLoc.split("^");
        $("#AppLoc").combobox('setValue',doctorLocStr[1]);
         $("#AppLoc").combobox('setText',doctorLocStr[0]);
        if(doctorLocStr[0].indexOf("����")>=0)
        {
            $("#IsOutOper").checkbox('setValue',true);
        }
    }
    var isOutOperRoom=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"GetIfOperLoc",
        ctlocId:logLocId
    },false)
    if(isOutOperRoom=="OUT")
	{
		$("#IsOutOper").checkbox('setValue',true);
	}
    var nurseWard=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"GetNurWard",
        userId:logUserId,
        ctlocId:logLocId
    },false);
    if(nurseWard&&nurseWard!="")
    {
        var nurseWardStr=nurseWard.split("^");
        $("#PatWard").combobox('setValue',nurseWardStr[1]);
    }
    var curRoomStr=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetRoomIdByIp",
        ipConfig:ClientIPAddress
    },false);
    if(curRoomStr!="")
    {
	    //����ǰ���������ģ�Ĭ�ϲ鿴����,�������������,20181221
	    $("#DateFrom").datebox('setValue',dateFrom);
    	$("#DateTo").datebox('setValue',dateFrom);
	    var curRoomDr=curRoomStr.split("^");
	    $("#OperRoom").combobox('setValue',curRoomDr[0]);
    }
    //�����ȫ��ά���˿���ǰ�鿴����
    var dateSpec=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"GetSpecGroupInitDate",
        userGroupId:logGroupId
    },false);
    if(dateSpec!="")
    {
	    $("#DateFrom").datebox('setValue',dateSpec);
    	$("#DateTo").datebox('setValue',dateSpec);
    }
}

//��ȡ��������
function getLogLocType(){
    var logLocType="App";
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if(locFlag==1) logLocType="OP";
	if(locFlag==2) logLocType="AN";
    return logLocType;
}
//��ȡ��¼�û�����
function getLogUserType(){
    var logUserType="";
    var userType=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetUserType",
        userId:logUserId
    },false);
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if((locFlag==1)||(locFlag==2))
    {
        if ((locFlag==1)&&(userType=="NURSE"))  logUserType="OPNURSE";
		if ((locFlag==2)&&(userType=="NURSE"))	logUserType="ANNURSE";
		if ((locFlag==2)&&(userType=="DOCTOR"))	logUserType="ANDOCTOR";
    }
    return logUserType;
}

function RegSearch()
{
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
        ClassName:"web.DHCDTHealthCommon",
        MethodName:"FormatPatientNo",
        PatientNo:$("#MedCareNo").val()
    },false);

		$("#MedCareNo").val(newregno);
		$HUI.datagrid("#OperListBox").load();
	}
}

//��ȡ����������
function getOpRoomList(){
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindAncOperRoom",
		ResultSetType:"array",
		oprDesc:"",
		locDescOrId:"sss",
		locListCodeStr:"OP^OUTOP^EMOP",
		EpisodeID:"",
		opaId:"",
		oprBedType:"T",
		appLocDescOrId:""
	},false)
	return result;	
}

//��ȡ̨������
function getOrdNo(){
	var maxOrdNo=30
	var data=new Array();
	for(var i=0;i<maxOrdNo;i++)
	{
		var no=i+1;
		var obj=new Object();
		obj={
			code:no,
			desc:no
			}
		data[i]=obj;
	}
	return data;	
}

//��ȡ�����һ�ʿ
function getOPNurseList(){
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindCtcp",
		ResultSetType:"array",
		needCtcpDesc:"",
		locListCodeStr:"OP^OUTOP^EMOP",
		locDescOrId:logLocId,
		EpisodeID:"",
		opaId:"",
		ifDoctor:"N",
		ifSurgeon:"N"
	},false)
	return result;
}
//��ȡ������
function getAnaMethodList(){
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindAnaestMethod",
		ResultSetType:"array",
		anmethod:""
	},false)
	return result;	
}

//��ȡ����ҽ��
function getANDoctorList(){
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindCtcp",
		ResultSetType:"array",
		needCtcpDesc:"",
		locListCodeStr:"AN^OUTAN^EMAN",
		locDescOrId:"",
		EpisodeID:"",
		opaId:"",
		ifDoctor:"Y",
		ifSurgeon:"N"
	},false)
	return result;
}

//��ȡ�ָ���λ
function getPACUBedList()
{
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindPacuRoom",
		ResultSetType:"array",
		test:""
	},false)
	return result;
}
function ClickIcoHandler(url)
	{
		var lnk=url.split("!")[0];
		var nwin=url.split("!")[1];
    var retValue = window.showModalDialog(lnk,"",nwin);
	}
function getIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i];
            idStr.push(id);
        }
    }
    return idStr;
}
