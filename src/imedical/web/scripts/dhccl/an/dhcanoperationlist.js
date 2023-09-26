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

//初始化表单控件
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
        data:[{'typedesc':"全部",'typecode':"A"},{'typedesc':"择期",'typecode':"B"},{'typedesc':"急诊",'typecode':"E"}]
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
//初始化手术列表
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
        //title:'手术列表结果',
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
                { field: "oproom", title: "术间", width: 80 ,
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
                { field: "opordno", title: "台次", width: 50 ,
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
                { field: "opSeqNote", title: "申请台次", width: 65 },
                { field: "loc", title: "科室", width: 140 },
                { field: "scrubnurse", title: "器械护士", width: 120 ,
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
                { field: "circulnurse", title: "巡回护士", width: 120 ,
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
                { field: "regno", title: "登记号", width: 95 },
                { field: "patname", title: "姓名", width: 70 },
                { field: "sex", title: "性别", width: 40 },
                { field: "age", title: "年龄", width: 45 },
                { field: "diag", title: "术前诊断", width: 180 },
                { field: "opname", title: "手术名称", width: 280 },
                { field: "bodsDesc", title: "部位", width: 80 },
                { field: "andoc", title: "麻醉医生", width: 80,
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

                { field: "anmethod", title: "麻醉方式", width: 120 ,
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
                { field: "bloodType", title: "血型", width: 40 },
                { field: "yy", title: "感染", width: 80 },
                { field: "Isolated", title: "隔离", width: 40 },
                { field: "opdoc", title: "手术医生", width: 160 },
                { field: "opDocNote", title: "术者备注", width: 65 },
                { field: "opmem", title: "手术要求", width: 80 },
                { field: "opdate", title: "开始时间", width: 120 },
                { field: "jzstat", title: "类型", width: 40 },
                { field: "dayOperFlag", title: "日间", width: 40 },
                { field: "OpAppDateStr", title: "手术申请时间", width: 100 },
                { field: "adm", title: "就诊号", width: 60 },
                { field: "ico", title: "Flag", width: 60 },
                { field: "oppack", title: "手术包", width: 100 },
                { field: "isAddInstrument", title: "是否补充器械", width: 100 },
                { field: "instrument", title: "器械", width: 40 },
                { field: "AnaesthesiaID", title: "AnaesthesiaID", width: 120 },
                { field: "patWard", title: "病区", width: 60 },
                { field: "medCareNo", title: "病案号", width: 60 },
                { field: "oprFloor", title: "术间楼层", width: 65 },
                { field: "opdatestr", title: "手术时间", width: 125 },
                { field: "estiOperDuration", title: "预计用时", width: 65 },
                { field: "preDiscussDate", title: "术前讨论日期", width: 60 },
                { field: "isExCirculation", title: "体外循环", width: 60 },
                { field: "anCompDesc", title: "合并疾病", width: 60 },
                { field: "isUseSelfBlood", title: "是否自体血回输", width: 60 },
                { field: "operPosition", title: "体位", width: 60 },
                { field: "OPCategory", title: "手术分类", width: 60 },
                { field: "operInstrument", title: "特殊器械", width: 60 },
                { field: "NeedAnaesthetist", title: "麻醉会诊", width: 60 },
                { field: "opsttime", title: "手术开始时间", width: 60 },
                { field: "retReason", title: "拒绝原因", width: 60 },
                { field: "opNurseOrd", title: "手术护士收费状态", width: 60 },
                { field: "anaDoctorOrd", title: "麻醉师收费状态", width: 60 },
                { field: "anaNurseOrd", title: "麻醉护士收费状态", width: 60 },
                { field: "tPacuBed", title: "恢复床位", width: 60 ,
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
                { field: "PACUInDateTime", title: "入恢复室时间", width: 60 },
                { field: "anDocAss", title: "麻醉助手", width: 60 },
                { field: "anNurse", title: "麻醉护士", width: 60 },
                { field: "topaAnSheetPrintAudit", title: "麻醉单打印审核", width: 60 },
                { field: "topaAnSheetEditAudit", title: "麻醉单修改审核", width: 60 },
                { field: "ASA", title: "ASA等级", width: 60 },
                { field: "opUnPlanedOperation", title: "重返手术", width: 60 },
                { field: "selfReport", title: "自述(门诊用)", width: 60 },
                { field: "operStock", title: "手术预备耗材", width: 60 },
                { field: "operStockNote", title: "手术预备耗材备注", width: 60 },
                { field: "appDocDesc", title: "申请医生", width: 60 },
                { field: "transferFlag", title: "调度", width: 60 
	                ,align:'center'
	                ,editable: true
					,formatter: function(value,metadata,record){
						var EpisodeID =record.adm;
						var url="dhcanopertransferlist.view.csp?&dateFrm="+$("#DateFrom").datebox('getValue')+"&dateTo="+$("#DateTo").datebox('getValue')+"&EpisodeID="+EpisodeID+"!"+"dialogWidth:1150px;dialogHeight:760px;status:no;menubar:no;";
						if(value==1){
							return '<img title="接人" src="../scripts/dhccl/img/recevice.png" onclick="ClickIcoHandler('+'\''+url+'\''+')" />';
						}
						else if(value==2){
							return '<img title="送人" src="../scripts/dhccl/img/send.png" onclick="ClickIcoHandler('+'\''+url+'\''+')"/>';
						}
						else
						{
							return ""
						}
					
				}
                },
                { field: "scNurNote", title: "器械备注", width: 100 },
                { field: "cirNurNote", title: "巡回备注", width: 100 },
                { field: "anDocNote", title: "麻醉医生备注", width: 100 },
                { field: "opaId", title: "opaId", width: 40 },
                { field: "PatientID", title: "PatientID", width: 40 },
                { field: "scrubNurseDr", title: "scrubNurseDr", hidden: true },
                { field: "circleNurseDr", title: "circleNurseDr", hidden: true },
                { field: "anmetDr", title: "anmetDr", hidden: true },
                { field: "PAADMMainMRADMDR", title: "PAADMMainMRADMDR", width: 40 },
                { field: "secretCode", title: "患者涉密", width: 60 },
                { field: "patLevel", title: "患者级别", width: 60 }
            ]                
        ],
        frozenColumns:[[
        { field: "check",checkbox:true },
        { field: "status", title: "状态", width: 50 
        ,styler:function(value,row,index){
	       var result=""
	       switch (row.status)
	       { 
	       	case '申请':
                    if(row.jzstat=='急诊') result='BACKGROUND-COLOR: #FFB8BE;';
                    break;
	      	case '拒绝':
                    result='BACKGROUND-COLOR: #10B5F5;'; //blue /refuse
                    break;
                case '安排':
                    result='BACKGROUND-COLOR: #94E290;';  //green //arranged
                    break;
                case '完成':
                    result='BACKGROUND-COLOR: #F9FFBC; ' ;//yellow //finish
                    break;
                case '术中':
                    result='BACKGROUND-COLOR: #FF0008;' ;//red 
                    break;
                case '术毕':
                    result='BACKGROUND-COLOR: #BEEDE3;' ;//light blue
                    break;
                case '恢复室':
                    result='BACKGROUND-COLOR: #FFD0FF;';
                    break;
                case '撤销':
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
		handler:function(){ //接受改变的值
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
							status:'安排',
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
							status:'安排',
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
		if ((field=='tPacuBed')&& (statusn != '术毕')) {
			$.messager.alert("提示","只能操作术毕状态的病人!","error");
			return false;
		}
		//alert(index)
		if((field == 'oproom')&&(statusn != '申请') && (statusn != '安排'))
		{
			$.messager.alert("提示","只能操作状态为安排或申请的手术!","error");
			return false;
		}
		if (field == 'opordno') {
			var value = selectRowObj.oproom;
			if (value == '无') {
				$.messager.alert("提示","请首先安排手术间!","error");
				return false;
			}
			if(statusn!='安排') 
			{ 
				$.messager.alert("提示","只能操作安排状态手术!","error");
				return false;
			}
		}
		if(field=='scrubnurse')   
		{
			if(statusn!='安排') 
			{ 
				$.messager.alert("提示","只能操作安排状态手术!","error");
				return false;
			}
		}
		if(field=='circulnurse')   
		{
			if(statusn!='安排') 
			{ 
				$.messager.alert("提示","只能操作安排状态手术!","error");
				return false;
			}
		}
		if((field=='anmethod')||(field=='andoc'))  
		{
			if(statusn!='安排') 
			{ 
				$.messager.alert("提示","只能操作安排状态手术!","error");
				return false;
			}
			if(logLocType!="AN")
			{return false;}
		}
		
		$("#OperListBox").datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
			editIndex = index;
	}
}	

//取新的安全组id   
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
//登录安全组加载菜单
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
//登录安全组加载按钮
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
        case "AppOperClinics":	 //门诊手术申请  add  by lyn  20160410
            //AppNewOper('ward',lnk,nwin,"Out");
            MZSSApply('ward',lnk,nwin,"Out");
            break;
        case "AppIntervent":	 //介入手术申请  add  by lyn  20160410
            AppNewOper('ward',lnk,nwin,"Inter");
            break;
        case "AlterOper":
            ManageOper('ward',lnk,nwin,"In");
            break;
        case "UpdateOperClinics":  //门诊修改手术申请
            MZSSAlter('ward',lnk,nwin,"Out");
            break;
        case "ArrOper":				
            HISUIManageOper('op',lnk,nwin,"In");
            break;  
        case "ArrOperClinics":  //门诊手术安排 add  by lyn  20160410
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
        case "RegOperClinics": //门诊术后登记 add  by lyn  20160410
           // ManageOper('RegOp',lnk,nwin,"Out");
           MZSSAlter('RegOp',lnk,nwin,"Out");
            break;
        case "PrintMZSSYYD":
            PrintMZSSYYD("MZSSYYD","N");
            break;
        case "PrintSSYYDBNZ":  //add by lyn 20160410  白内障科室
            var closeWindow = confirm("是否导出？(取消将直接打印)");
            if(closeWindow) PrintAnOpList("SSYYDBNZ","Y");
            else PrintAnOpList("SSYYDBNZ","N");
            break;
        case "PrintSSYYDTY":  //add by lyn 20160517  眼科
            var closeWindow = confirm("是否导出？(取消将直接打印)");
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
        case "OperTransfer":     //患者转运申请 add by YuanLin 20170815
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
	  case "ANAuditDayOper":	//日间术前评估
            btnANAuditOper();
            break;
	  case "ANPostDayOperAcess":	//日间术后评估
            btnANPostAcess();
            break;
      case "ANDayOutAcess":	//日间出院评估
            btnANDayOutAcess();
            break; 
       case "DHCANOPNurseRecord":	//手术护理
       		DHCANOPNurseRecord();
       		break;
       case 'MaterialListTotal':	//20191029+dyl+材料清单统计
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
        case 'btnOpRoomLimit': //中国医大用
            btnOpRoomLimit_click();
            break;
        case 'btnOpRoomOpen': //中国医大用
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
        case 'btnCancelOper': //撤销手术，不同于拒绝手术
            btnCancelOper_click();
            break;
        case 'CheckRiskAssessment': //手术风险评估：申请医生
            CheckRiskAssessment();
            break;
        case 'CheckSafetyInfo':	//手术安全核查：麻醉医生
            CheckSafetyInfo();
            break;
        case "OPControlledCost":		//可控成本
            OPControlledCost();
            break;
        case "ANEquip":	//麻醉设备管理
            ANEquip();
            break; 
		 case "InRoomCheck":  //入室核查
           	ReceivePat("InRoom");
           	break;
        case "OutRoomCheck":  //离室核查
           	ReceivePat("OutRoom");
           	break;
		case "OperAssess":  //麻醉评分
           	OperAssess();
           	break;
    case "RegMaterialList":  //手术材料清单20191028+dyl
           	RegMaterialList();
           	break;
       
        default:
            break;
    }
}
//表单控件加载默认值
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
        if(doctorLocStr[0].indexOf("门诊")>=0)
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
	    //如果是绑定了手术间的，默认查看当天,本手术间的手术,20181221
	    $("#DateFrom").datebox('setValue',dateFrom);
    	$("#DateTo").datebox('setValue',dateFrom);
	    var curRoomDr=curRoomStr.split("^");
	    $("#OperRoom").combobox('setValue',curRoomDr[0]);
    }
    //如果安全组维护了可往前查看天数
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

//获取科室类型
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
//获取登录用户类型
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

//获取手术间数据
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

//获取台次数据
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

//获取手术室护士
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
//获取麻醉方法
function getAnaMethodList(){
	var result=$.cm({
		ClassName:"web.UDHCANOPArrange",
		QueryName:"FindAnaestMethod",
		ResultSetType:"array",
		anmethod:""
	},false)
	return result;	
}

//获取麻醉医生
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

//获取恢复床位
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
