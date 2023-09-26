var IsCellCheckFlag = false; //标示主管医生、便签列是否点击，true - 是 , false - 否
$(function(){
	InitCombo();
	InitInPatientList();
    DocElementEventInit();
});
function DocElementEventInit(){
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="TransDept")||(PatListObj.PatListType=="OperationPat")){
		$(".selinpatdaybtn").removeClass("selinpatdaybtn");
		$("#DateGap1Radio").addClass("selinpatdaybtn");
		$(".inpatdaybtncom").click(InpatDayBtnClick);
	}
	if ((PatListObj.PatListType!="OperationPat")&&(PatListObj.PatListType!="CriticallyPat")){
		if (PatListObj.PatListType!="InPat"){
			$(".SelectedLiCls").removeClass("selinpatbtn");
			if (session['LOGON.WARDID']==""){
				$("#currentLocBtn").addClass("selinpatbtn");
			}else{
				if ($("#currentUserBtn").length>0) {
					$("#currentUserBtn").addClass("selinpatbtn");
				}else{
					$("#currentLocBtn").addClass("selinpatbtn");
				}
			}
		}
		$(".inpatbtncom").click(InpatBtnClick);	
	}
	if (PatListObj.PatListType=="InPat"){
		$(".backcolorcom").click(backcolorBtnClick);	
	}
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="InPat")||(PatListObj.PatListType=="CurWarPat")||(PatListObj.PatListType=="InHospTransPat")||(PatListObj.PatListType=="PreAdmissionPatList")||(PatListObj.PatListType=="TransDept")){
		$('#medicareNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				GetData();
			}
		});
		$('#patientNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				setpatientNoLength();
			}
		});
		if ($("#patientName").length>0){
			$('#patientName').bind('keypress', function(event) {
				if (event.keyCode == "13") {
					GetData();
				}
			});
		}
		if ($("#patbedNo").length>0){
			$('#patbedNo').bind('keypress', function(event) {
				if (event.keyCode == "13") {
					GetData();
				}
			});
		}
		if ($("#DeliveryPatient").length>0){
			var Deliveryrtn=$.cm({ 
				ClassName:"web.DHCDocInPatientListNew",
				MethodName:"CheckForDeliveryPatient", 
				dataType:"text",
				locID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID']
			},false);
			if (Deliveryrtn!=0){
				$HUI.checkbox("#DeliveryPatient",{
					onCheckChange:function(){
						GetData();
						}
					})
			}else{
				$("#tdDeliveryPatient").hide();
				}
		}
		$HUI.linkbutton("#Search1",{
			onClick:function(){
				GetData();
			}
		});
	}
	if (PatListObj.PatListType=="DisChargePat"){
		$(".inpatbtncom").click(InpatBtnClick);	
		$("#curWardBtn").addClass("selinpatbtn");
		$(".selinpatdaybtn").removeClass("selinpatdaybtn");
		$("#DateGap1Radio").addClass("selinpatdaybtn");
		$(".inpatdaybtncom").click(InpatDayBtnClick);
	}
	if ((PatListObj.PatListType=="CurWarPat")||(PatListObj.PatListType=="InHospTransPat")){
		$('#patientName,#patbedNo').bind('keypress', function(event) {
			if (event.keyCode == "13") {
				GetData();
			}
		});
	}
}
function InitCombo(){
	if (PatListObj.PatListType=="InPat"){
		InitWardCombo();
		InitDoctorName();
	}
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="CurWarPat")||(PatListObj.PatListType=="InHospTransPat")){
		InitDoctorName();
	}
}
//Desc: 初始化病区下拉框
function InitWardCombo()
{
	$('#wardcombo').combobox({
		
		url:'../web.DHCDocInPatientListNew.cls?action=GetWardList&LocID=' + session['LOGON.CTLOCID'],    
		valueField:'LocID',    
		textField:'LocDesc',
		filter: function(q, row){
			q=q.toUpperCase();
			return (row["LocDesc"].toUpperCase().indexOf(q) >= 0)||(row["Alias"].toUpperCase().indexOf(q) >= 0);
		},
		onSelect:function() {
			GetData();
		},
		onLoadSuccess:function(data){
			$(this).combobox("setValue",PatListObj.DefaultCurrentWard);
		},
		onChange:function(newValue,oldValue){
			if (newValue=="") {
				GetData();
			}
		}
	});
}
//初始化主管医师
function InitDoctorName()
{
	$('#userName').combobox({
		url:'../web.DHCDocInPatientListNew.cls?action=GetUserName',  
	    valueField:'UserCode',  
	    textField:'UserDesc',
	    onLoadSuccess:function(d){
	    	var data=eval(d);
	    	if ($('#currentUserRadio').attr('checked') == "checked"){
		    	$.each(data,function(idx,val){
					//若当前选中本人病人，则默认值为登录用户名，且主管医师下拉框不可选
					if (val.UserCode == userCode){
						$('#userName').combobox('select',userCode);
						$('#userName').combobox('disable');
						return
					}
				});
	    	}
	    },onSelect:function() {
		    GetData();
		},filter: function(q, row){
			if (q=="") return true;
			if ((row["UserCode"].indexOf(q.toUpperCase())>=0)||(row["UserDesc"].indexOf(q.toUpperCase())>=0)||(row["OtherName"].indexOf(q.toUpperCase())>=0)) return true;
			return false;
		}
    });
}
//Desc:病人列表信息
function InitInPatientList()
{
	var url="";
	var defaultRadio="currentUser";
	var WardID="all";
	if (PatListObj.PatListType=="InPat"){
		if (PatListObj.DefindeListShow==1) { 
			defaultRadio="currentUser";
		}else if (PatListObj.DefindeListShow==2){ 
			defaultRadio="currentLoc";
		}else if (PatListObj.DefindeListShow==3){ 
			defaultRadio="currentGroup";
		}else{
			defaultRadio="currentUser";
		}
		$(".SelectedLiCls").removeClass("selinpatbtn");
		$("#"+defaultRadio+"Btn").addClass("selinpatbtn");
		if (PatListObj.DefaultCurrentWard!="") {
			WardID=PatListObj.DefaultCurrentWard;
		}
	}
	if ((PatListObj.PatListType=="InPat")||(PatListObj.PatListType=="CurWarPat")||(PatListObj.PatListType=="InHospTransPat")){
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType='+PatListObj.PatListType+'&RadioValue=' + defaultRadio+'&WardID='+WardID;
		PatListColumns=[[  
			{field:'PatientID',title:'PatientID',width:80,hidden: true},
			{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
			{field:'mradm',title:'mradm',width:80,hidden: true},
			{field:'PAAdmBedNO',title:'床号',width:50,sortable:true},
			{field:'PAPMINO',title:'登记号',width:95,sortable:true},
			{field:'PAPMIName',title:'姓名',width:65,sortable:true},
			{field:'ColorDesc',title:'状态 ',width:50,
				styler: function(value,row,index){
					if (value!=""){
						return 'background-color:'+value+';border-radius: 0px;color:#FFF;';
					}
				},
				formatter: function(value,row,index){
					return row.ColorStatus;
				}

			},
			{field:'NurseAccp',title:'护士拒绝',
				styler: function(value,row,index){
					if (value!=""){
						return 'color:red;';
					}
				},width:80
			},
			
			{field:'CPWSStatus',title:'入径状态',width:80,sortable:true},
			
			{field:'PAPMISex',title:'性别',width:50,sortable:true},
			{field:'PAPMIAge',title:'年龄',width:50,sortable:true},
			{field:'IconProfile',title:'图标菜单',width:80,
				formatter: function(value,row,index){
					return reservedToHtml(value);
				}
			},
			{field:'PAAdmWard',title:'病区',width:150,sortable:true},
			{field:'PAAdmDate',title:'就诊日期',width:95,sortable:true},
			{field:'PAAdmTime',title:'就诊时间',width:85,sortable:true},
			{field:'MedicareNo',title:'病案号',width:70,sortable:true},
			{field:'InTimes',title:'入院次数',width:80,sortable:true},
			{field:'ResidentDays',title:'住院天数',width:80,sortable:true},
			{field:'PAAdmDocCodeDR',title:'主管医师',width:80,sortable:true,
				formatter:function(value,rec){  
					if (value!="无"){
	                   var btn = '<a href="#"  class="editcls"  onclick="DocThreeCheckListShow(\'' + rec.EpisodeID + '\')">'+value+'</a>';
					}else{var btn =value
					      }
					return btn;
                }
			},
			{field:'HeadUniteDoc',title:'带组医师',width:80},
			{field:'ChiefDoc',title:'主任医师',width:80},
			{field:'PAAdmReMark',title:'医生便签',width:80,sortable:true,
				formatter:function(value,rec){  
					if ((value)&&(value!="")&&(value!=" ")){
	                   var btn = '<a href="#" id ="Remark'+rec.EpisodeID +'"title="'+value+'" class="hisui-tooltip" onmouseover="PAAdmReMarkonmouse(\'' + rec.EpisodeID+ '\') " onclick="PAAdmReMarkShow(\'' + rec.EpisodeID + '\',\''+rec.PAPMIName+'\')">'+value+'</a>';
					}else{
					   var btn = '<a href="#"  class="editcls" onclick="PAAdmReMarkShow(\'' + rec.EpisodeID + '\',\''+rec.PAPMIName+'\')"><img src="../scripts/dhcdoc/dhcapp/images/adv_sel_11.png" title="医生便签" border="0"></a>';
					}
					return btn;
                }
			},
			{field:'Diagnosis',title:'诊断',width:150,sortable:true},
			{field:'PAAdmReason',title:'患者费别',width:80,sortable:true}
		]];
	}
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="DisChargePat")){
		var DisDay=0; //默认当天
		var DisType=0; //默认本病区
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType='+PatListObj.PatListType+'&RadioValue=' + defaultRadio + '&DateGap=0';
		url=url+'&DisDay='+DisDay+'&DisType='+DisType;
		PatListColumns=[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAAdmDischgeDate',title:'出院日期',width:100,sortable:true},
				{field:'PAAdmDischgeTime',title:'出院时间',width:100},
				{field:'PAAdmBedNO',title:'出院床号',width:80},
				{field:'PAPMINO',title:'登记号',width:90},
				{field:'PAPMIName',title:'姓名',width:80},  
				{field:'PAPMISex',title:'性别',width:50},
				{field:'PAPMIAge',title:'年龄',width:80},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'MedicareNo',title:'病案号',width:80},
				{field:'InTimes',title:'住院次数',width:80},
				{field:'OutDays',title:'出院天数',width:80},
				{field:'PAAdmDocCodeDR',title:'主管医师',width:80},
				{field:'HomepageURL',title:'病案首页',width:80},
				{field:'IsRecordCompleted',title:'是否提交',width:90},
				{field:'MedicareTime',title:'病案编目时间',width:80}/*,
				{field:'SecAlias',title:'病人密级',width:80},
				{field:'EmployeeFunction',title:'病人级别',width:80}*/
			]];
	}
	if (PatListObj.PatListType=="TransDept"){
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType=TransDept&RadioValue=currentLoc&DateGap=0';
		PatListColumns=[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'Status',title:'状态',width:60,
					styler: function(value,row,index){
						if (value!="在院"){
							return 'background-color:#F05AD7;color:#FFF;'
						}
					}
				},
				{field:'TransStartDate',title:'转出日期',width:100},
				{field:'TransStartTime',title:'转出时间',width:80},
				{field:'TransBedNO',title:'转出床号',width:80},
				{field:'PAPMINO',title:'登记号',width:100},
				{field:'PAPMIName',title:'姓名',width:80},
				{field:'PAPMISex',title:'性别',width:50},
				{field:'PAPMIAge',title:'年龄',width:50},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PatMedicareNo',title:'病案号',width:100},
				{field:'PAAdmDepCodeDR',title:'当前科室',width:180},
				{field:'PAAdmBedNO',title:'当前床号',width:80},
				{field:'PAAdmDocCodeDR',title:'主管医生',width:80},
				{field:'TransURL',title:'转出记录',width:80},
				{field:'SecAlias',title:'患者密级',width:80},
				{field:'EmployeeFunction',title:'患者级别',width:80}
			]];
	}
	if (PatListObj.PatListType=="OperationPat"){
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType=OperationPat&DateGap=0';
		PatListColumns=[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'opdatestr',title:'手术日期',width:160},
				{field:'PAAdmBedNO',title:'床号',width:50},
				{field:'PAPMINO',title:'登记号',width:100},  
				{field:'PAPMIName',title:'姓名',width:80},
				{field:'PAPMISex',title:'性别',width:50},
				{field:'PAPMIAge',title:'年龄',width:50},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'opdes',title:'手术名称',width:260}, 
				{field:'OPCategory',title:'手术级别',width:80},
				{field:'PreOPConferURL',title:'术前讨论',width:80},
				{field:'OPRecordURL',title:'手术记录',width:80},
				{field:'AfterOPFirstURL',title:'术后首程',width:90},
				{field:'SecAlias',title:'患者密级',width:80},
				{field:'EmployeeFunction',title:'患者级别',width:80}
			]];
			
	}
	if (PatListObj.PatListType=="CriticallyPat"){
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType=CriticallyPat';
		PatListColumns=[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'PAAdmBedNO',title:'床号',width:50},
				{field:'PAPMINO',title:'登记号',width:100},  
				{field:'PAPMIName',title:'姓名',width:80},
				{field:'PAPMISex',title:'性别',width:50},
				{field:'PAPMIAge',title:'年龄',width:50},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'CareClass',title:'护理级别',width:80},
				{field:'Vitalsigns',title:'生命体征',width:200}, 
				{field:'PAAdmDocCodeDR',title:'主管医师',width:90},
				{field:'HeadUniteDoc',title:'带组医师',width:90},
				{field:'ChiefDoc',title:'主任医师',width:90},
				{field:'Diagnosis',title:'诊断',width:150},
				{field:'SecAlias',title:'患者密级',width:80},
				{field:'EmployeeFunction',title:'患者级别',width:80},
			]];
	}
	
	//预入院患者
	if (PatListObj.PatListType=="PreAdmissionPatList"){
		url='../web.DHCDocInPatientListNew.cls?action=GetPatientList&PatListType=PreAdmissionPatList';
		PatListColumns=[[  
				{field:'PatientID',title:'PatientID',width:80,hidden: true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden: true},
				{field:'mradm',title:'mradm',width:80,hidden: true},
				{field:'NumSeq',title:'序号',width:50},  
				{field:'PAPMINO',title:'登记号',width:100 ,sortable:true},  
				{field:'PAPMIName',title:'姓名',width:100},
				{field:'PAPMISex',title:'性别',width:50},
				{field:'PAPMIAge',title:'年龄',width:50},
				{field:'PAPMIDOB',title:'出生日期',width:100,sortable:true},
				{field:'Diagnosis',title:'诊断',width:150},
			]];
	}
	
	
	$('#patientListData').datagrid({ 
		width:'100%',
		height:'100%', 
		pageSize:15,
		pageList:[15,30,50,100], 
		fitColumns: false,
		loadMsg:$g('数据装载中......'),
		autoRowHeight: false,
		url:url,
		singleSelect:true,
		idField:'EpisodeID', 
		rownumbers:false,
		pagination:true,
		fit:true,
		remoteSort:true,
		//sortName:"PAAdmBedNO",
		columns:PatListColumns,
		onDblClickRow: function() {
			if (IsCellCheckFlag==true) return false;
			var seleRow = $('#patientListData').datagrid('getSelected');
			if (seleRow){
				doSwitch(seleRow.PatientID,seleRow.EpisodeID,seleRow.mradm); 
			}
		},onLoadSuccess:function(data){
			IsCellCheckFlag=false;
			if ((PatListObj.PatListType=="InPat")||(PatListObj.PatListType=="CurWarPat")){
					$("#BZCount")[0].innerHTML=$g("病重")+"("+data.SCount+")";
					$("#BWCount")[0].innerHTML=$g("病危")+"("+data.CCount+")";
					$("#CurPatCount")[0].innerHTML=$g("新入")+"("+data.FCount+")";
					if (PatListObj.ShowFromPage!="FromChart") {
						if (PatListObj.PatListType=="InPat"){
							var selName=$(".selinpatbtn")[0].innerText.replace($g("患者"),"").replace($g("病人"),"");
							if (data.BabyNum>0){
								$('#CurLocInPatCount', window.parent.document)[0].innerHTML=selName+""+(data.total-data.BabyNum)+"+"+data.BabyNum;
							}else{
								$('#CurLocInPatCount', window.parent.document)[0].innerHTML=selName+""+data.total;
							}
							var selId=$(".selinpatbtn")[0].id;
							if (selId=="currentLocBtn"){
								//$('#CurLocCriticallyPatCount', window.parent.document)[0].innerHTML=selName+""+(data.SCount+data.CCount);
								$('#CurLocCriticallyPatCount', window.parent.document)[0].innerHTML=data.SCount+data.CCount;
							}
						}else{
							$('#CurLocInPatCount', window.parent.document)[0].innerHTML=data.total;
						}
					}
				}
				if (PatListObj.ShowFromPage!="FromChart") {
					if (PatListObj.PatListType=="OutPat"){
						$('#OuPatListCount', window.parent.document)[0].innerHTML=data.total;
					}
					if (PatListObj.PatListType=="TransDept"){
						$('#TransOutPatListCount', window.parent.document)[0].innerHTML=data.total;
					}
					if (PatListObj.PatListType=="CriticallyPat"){
						$('#CurLocCriticallyPatCount', window.parent.document)[0].innerHTML=data.total;
					}
					if (PatListObj.PatListType=="OperationPat"){
						$('#OperationPatCount', window.parent.document)[0].innerHTML=data.total;
					}
					if (PatListObj.PatListType=="PreAdmissionPatList"){
						$('#PreAdmissionCount', window.parent.document)[0].innerHTML=data.total;
					}
				}
			
			//隐藏行选择数，只按默认显示15个
			//$(".pagination-page-list").hide();
			
			if (data.rows.length>0 && typeof data.rows[0].IconProfile !="undefined"){
				setTimeout(function () {
					StartLoading(0);
				},1000);
			}
			function StartLoading(StartRow) {
				var AdmList=[];
				for (RowIndex=0;RowIndex<data.rows.length;RowIndex++){
					AdmList.push({
						"index":RowIndex,
						"EpisodeID":data.rows[RowIndex].EpisodeID,
						"PatientID":data.rows[RowIndex].PatientID
					});
				}
				var AdmListJson=JSON.stringify(AdmList);
				$.cm({
					ClassName:"web.DHCDocInPatientListNew",
					MethodName:"GetIconList",
				    AdmListJson:AdmListJson,
				    CONTEXT:session['CONTEXT']
				},function(Icondata){
					var patientListDataGrid=$('#patientListData');
					var options=patientListDataGrid.datagrid("options");
					var FieldName="IconProfile";
					var formatter=patientListDataGrid.datagrid("getColumnOption", FieldName).formatter;
					var Length=Icondata.length;
					for (var i=0;i<Length;i++){
						if (data.rows[Icondata[i].index].EpisodeID!=Icondata[i].EpisodeID){
							continue
						}
						//改成直接操作DOM，不使用HUI方法，提高效率
						var FieldName$=options.finder.getTr(patientListDataGrid[0],Icondata[i].index,"body",2).children('td[field="'+FieldName+'"]').find("div");
						if (FieldName$.html()==""){
							var FieldHTML=formatter?formatter(Icondata[i].IconProfile):Icondata[i].IconProfile;
							FieldName$.append(FieldHTML);
						}
						/*
						patientListDataGrid.datagrid('updateRow',{
							index: Icondata[i].index,
							row: {
								IconProfile:Icondata[i].IconProfile
							}
						});
						*/
						
					}
				});
			}
		},onLoadError:function(){
		},onSelect:function(index, row){
			if (IsCellCheckFlag==true) return false;
			var frm=parent.parent.parent.document.forms['fEPRMENU'];
			var frmEpisodeID=frm.EpisodeID;
			var frmPatientID=frm.PatientID;
			var frmmradm=frm.mradm;
			var frmcanGiveBirth=frm.canGiveBirth;
			var OldEpisodeID=frmEpisodeID.value;
			
			frmPatientID.value=row["PatientID"];
			frmEpisodeID.value=row["EpisodeID"];
			frmmradm.value=row["mradm"];
			if (row["PAPMISex"]==$g("女")){
				frmcanGiveBirth.value=1;
			}else{
				frmcanGiveBirth.value=0;
			}
			frm.AnaesthesiaID.value="";
			//防止和双击行事件同时触发界面局部刷新方法，导致datagrid-scrolling的bug（无法正常回调onloadsuccess方法）
			if (OldEpisodeID==row["EpisodeID"]){
				return;
			}
			switchPatient(row["PatientID"],row["EpisodeID"],row["mradm"]);
			//PAPMISex
		},onBeforeSelect:function(index, row){
			if (IsCellCheckFlag==true) return false;
		},onBeforeLoad:function(param){
			$('#patientListData').datagrid('unselectAll')
		}
	});
 }
function InpatBtnClick(e){
	var id=e.target.id;
    $(".selinpatbtn").removeClass("selinpatbtn");
	$("#"+id+"").addClass("selinpatbtn");
	GetData();
}
function InpatDayBtnClick(e){
	var id=e.target.id;
    $(".selinpatdaybtn").removeClass("selinpatdaybtn");
	$("#"+id+"").addClass("selinpatdaybtn");
	if (id=="DateFreeRadio"){
		$("#DateFree-dialog").dialog("open");
		$("#BFindDate").click(BFindDateBtnClick);
	}else{GetData();}
}
function BFindDateBtnClick(){
	GetData();
	$("#DateFree-dialog").dialog("close");
	}
//查询数据
function GetData()
{
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="TransDept")||(PatListObj.PatListType=="OperationPat")||(PatListObj.PatListType=="DisChargePat")){
		//获取日期间隔
		var selDateDapId=$(".selinpatdaybtn")[0].id;
		var DateGap="",StartDate="",EndDate="";
		if (selDateDapId=="DateGap1Radio") DateGap="0"
		if (selDateDapId=="DateGap3Radio")  DateGap="2"
		if (selDateDapId=="DateGap7Radio") DateGap="6"
		if (selDateDapId=="DateGap30Radio") DateGap="29"
		if (selDateDapId=="DateGap60Radio") DateGap="59"
		if (selDateDapId=="DateGap90Radio") DateGap="89"
		if (selDateDapId=="DateFreeRadio") {
			var StartDate=$HUI.datebox("#StartDate").getValue();
			var EndDate=$HUI.datebox("#EndDate").getValue();
			}
	}
	if ((PatListObj.PatListType=="InPat")||(PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="TransDept")){
		//获取病人范围
		var selId=$(".selinpatbtn")[0].id;
		var RadioValue="";
		if (selId=="currentUserBtn") RadioValue="currentUser"
		if (selId=="currentLocBtn")  RadioValue="currentLoc"
		if (selId=="currentGroupBtn") RadioValue="currentGroup"
		if (selId=="currentDocContorBtn") RadioValue="currentDocContor"
	}
	var Delivery=0
	if ((PatListObj.PatListType=="InPat")||(PatListObj.PatListType=="CurWarPat")||(PatListObj.PatListType=="InHospTransPat")){
		if (PatListObj.PatListType=="InPat"){
			var WardID = $('#wardcombo').combobox('getValue');
			var WardText = $('#wardcombo').combobox('getText');
			if (WardText == "" || WardText == "undefinded"){
				WardID = "all";
			}
			var patientNo="";
			var Delivery=$HUI.checkbox("#DeliveryPatient").getValue()
			if (Delivery==true) {Delivery=1; }else{Delivery = 0;}
		}else{
			var WardID="";
			var patientNo=$("#patientNo").val();
		}
		var DocCode=$('#userName').combobox('getValue');
		var medicareNo=$("#medicareNo").val();
		var patientName=$("#patientName").val();
		var patientBedNo=$("#patbedNo").val();
		
		$('#patientListData').datagrid('load', {
			action: "GetPatientList",
			PatListType: PatListObj.PatListType,
	   	 	RadioValue: RadioValue,
	   	 	WardID: WardID,
	   	 	MedicareNo: medicareNo,
	    	PatientName: patientName,
	    	patientBedNo: patientBedNo,
	    	patientNo:patientNo,
	    	DocCode:DocCode,
	    	DeliveryPatient:Delivery,
	    	BZStr:PatListObj.BZStr
		});
	}
	PatListObj.BZStr=""
	if ((PatListObj.PatListType=="OutPat")||(PatListObj.PatListType=="DisChargePat")){
		var DisType="";
		if (PatListObj.PatListType=="DisChargePat"){
			/*var selId=$(".selinpatbtn")[0].id;
			if (selId=="curWardBtn") DisType=0
			if (selId=="curUserBtn") DisType=1*/
			DisType=0;
			var RadioValue="",patientNo="",medicareNo="",patientName="",userNameCode=""
		}else{
			var patientNo = $("#patientNo").val();
			var medicareNo = $("#medicareNo").val();
			var patientName = $("#patientName").val();
			var userNameCode = $("#userName").combobox('getValue');
			//IE11中，利用下拉框中的“叉号”去掉下拉框内容时，实际上下拉框的值没有去掉，所以查询时需要手动根据下拉框的文本内容判断一下下拉框的值是否应该为空
			var userNameText = $('#userName').combobox('getText');
			if (userNameText == "" || userNameText == "undefinded"){
				userNameCode = "";
			}
		}
		$('#patientListData').datagrid('load', {
			action: "GetPatientList",
			PatListType: PatListObj.PatListType,
	   	 	RadioValue: RadioValue,
			DateGap: DateGap,
	    	PatientNo: patientNo,
	    	MedicareNo: medicareNo,
	    	PatientName: patientName,
	    	UserCode: userNameCode,
	    	DisType:DisType,
	    	DisDay:DateGap,
	    	StartDate:StartDate,
			EndDate:EndDate
		});
	}
	
	if (PatListObj.PatListType=="TransDept"){
		var medicareNo=$("#medicareNo").val();
		var patientNo=$("#patientNo").val();
		$('#patientListData').datagrid('load', {
			action: "GetPatientList",
			PatListType: "TransDept",
	   	 	RadioValue: RadioValue,
			DateGap: DateGap,
			medicareNo:medicareNo,
			patientNo:patientNo,
			StartDate:StartDate,
			EndDate:EndDate
		});
	}
	if (PatListObj.PatListType=="OperationPat"){
		$('#patientListData').datagrid('load', {
	    	DateGap: DateGap	
		});
	}
	
	//预入院
	if (PatListObj.PatListType=="PreAdmissionPatList"){
			var patientNo = $("#patientNo").val();
			var medicareNo = $("#medicareNo").val();
			var PatientName = $("#patientName").val();
			$('#patientListData').datagrid('load', {
				action: "GetPatientList",
				patientNo: patientNo,
	    		PatientName: PatientName,
		});
	}
}

//Desc:切换患者 parent
function doSwitch(PatientID,EpisodeID,mradm) {
	doSwitch(PatientID,EpisodeID,mradm);
}
function setpatientNoLength(){
	var patientNo = $("#patientNo").val();
	if (patientNo != '') {
		for (var i=(10-patientNo.length-1); i>=0; i--){
			patientNo ="0"+ patientNo;
		}
	}
	$("#patientNo").val(patientNo);
	GetData();
}
function reservedToHtml(str){
	var replacements = {"&lt;":"<", "&#60;":"<", "&gt;":">", "&#62;":">", "&quot;":"\"", "&#34;":"\"", "&apos;":"'",
	"&#39;":"'", "&amp;":"&", "&#38;":"&"};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g,function(v){
		return replacements[v];		
	});
}
//获取头菜单信息
function getMenuForm() {
    var win = top.frames['eprmenu'];
    if (win) {
        var frm = win.document.forms['fEPRMENU'];
        return frm;
    }

    var frm = parent.frames[0].document.forms["fEPRMENU"];
    if (frm) return frm;
    frm = top.document.forms["fEPRMENU"];
    return frm
}
function switchPatient(PatientID,EpisodeID,mradm){
	if(top.frames[0] && top.frames[0].switchPatient){
		top.frames[0].switchPatient(PatientID,EpisodeID,mradm);
		top.frames[0].hidePatListWin();
	}else if (parent.switchPatient){
		parent.switchPatient(PatientID,EpisodeID,mradm);
		parent.hidePatListWin();
	}else{
		parent.parent.switchPatient(PatientID,EpisodeID,mradm);
		parent.parent.hidePatListWin();
	}
}
//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	//防止和单击行事件同时触发界面局部刷新方法，导致datagrid-scrolling的bug（无法正常回调onloadsuccess方法）
	var frm=parent.parent.parent.document.forms['fEPRMENU'];
	var OldEpisodeID=frm.EpisodeID.value;
	
	if(top.frames[0] && top.frames[0].switchPatient){
		if (OldEpisodeID!=EpisodeID){
			top.frames[0].switchPatient(PatientID,EpisodeID,mradm);
		}
		top.frames[0].hidePatListWin();
	}else{
		if (OldEpisodeID!=EpisodeID){
			parent.parent.switchPatient(PatientID,EpisodeID,mradm);
		}
		parent.parent.hidePatListWin();
	}
	return ;
}
 //浏览相应的病历
function BrowserRecord(id,pluginType,chartItemType,emrDocId)
{
	IsCellCheckFlag=true;
	var src="emr.record.browse.browsform.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId;
	websys_showModal({
		url:src,
		//title:"记录列表",
		width:'80%',height:'80%'
	});
	//window.open("emr.record.browse.browsform.editor.csp?id="+id+"&pluginType="+pluginType+"&chartItemType="+chartItemType+"&emrDocId="+emrDocId,"");
	setTimeout(function(){
		IsCellCheckFlag=false;
	})
}
function DocThreeCheckListShow(EpsiodeID){
	IsCellCheckFlag=true;
	var src="dhcdocthreechecklist.hui.csp?EpisodeID="+EpsiodeID+"&LocID="+ session['LOGON.CTLOCID']+"&UserID="+session['LOGON.USERID'];
	websys_showModal({
		url:src,
		title:"三级检诊维护",
		width:600,height:620
	});
	setTimeout(function(){
		IsCellCheckFlag=false;
	})
}
function PAAdmReMarkShow(EpsiodeID,PAPMIName){
	IsCellCheckFlag=true;
	 websys_showModal({
			url:"dhcdocadmremark.csp?EpisodeID="+EpsiodeID,
			title:PAPMIName+':'+$g('医生便签'),
			width:300,height:220,
			ChangePAAdmReMark:ChangePAAdmReMark
	});
	setTimeout(function(){
		IsCellCheckFlag=false;
	})
}
function ChangePAAdmReMark(Text){
	GetData();
}
function PAAdmReMarkonmouse(EpisodeID){
	$HUI.tooltip("#Remark"+EpisodeID,{position:'left'}).show();
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function backcolorBtnClick(){
	PatListObj.BZStr= this.id
	GetData();
}
/*******实现语音功能函数 开始**********/
/**
 * CTOR: QP
 * DESC: 选择病人
 * @voicePara {*} 参数 
 */
function SelectPatient(voicePara) {
	var P1 = "";
	//解析voicePara
	if (voicePara&&(typeof voicePara.P1!="undefined")) {
		P1=voicePara.P1;
	}
	//alert("P1: "+P1)
	//页面层面操作选择
	var allData = $('#patientListData').datagrid("getData");
	var total = allData.total;
	var currentSize = allData.rows.length;
	if (total>0) {
		for (var i=0; i<currentSize; i++) {
			var cRecord = allData.rows[i];
			var cBedNo = cRecord.PAAdmBedNO;
			if ((cBedNo == P1)||(cBedNo == ("0"+P1))) {
				$('#patientListData').datagrid("selectRow",i)
				doSwitch(cRecord.PatientID,cRecord.EpisodeID,cRecord.mradm); 
				return
			}
		}
	}
	return true;
}
/**
 * CTOR: QP
 * DESC: 上一页
 * @voicePara {*} 参数 
 */
function PrevPage(voicePara) {
	var pagerObj = $('#patientListData').datagrid("getPager");
	var options = pagerObj.pagination("options");
	var pageSize = options.pageSize,
		pageNumber = options.pageNumber,
		total = options.total;
	
	if (total<=0) return false;
	var totalPageNumber = Math.ceil(total/pageSize),
		prevPage = pageNumber - 1;
	if (pageNumber == 0) {
		prevPage = totalPageNumber;
	}	
	pagerObj.pagination('select', prevPage);
	
	return true;
}
/**
 * CTOR: QP
 * DESC: 下一页
 * @voicePara {*} 参数 
 */
function NextPage(voicePara) {
	var pagerObj = $('#patientListData').datagrid("getPager");
	var options = pagerObj.pagination("options");
	var pageSize = options.pageSize,
		pageNumber = options.pageNumber,
		total = options.total;
	
	if (total<=0) return false;
	var totalPageNumber = Math.ceil(total/pageSize),
		nextPage = pageNumber + 1;
	if (pageNumber == totalPageNumber) {
		nextPage = 1;
	}
	//alert(nextPage);
	pagerObj.pagination('select', nextPage);
	
	return true;
}
/*******实现语音功能函数 结束**********/
