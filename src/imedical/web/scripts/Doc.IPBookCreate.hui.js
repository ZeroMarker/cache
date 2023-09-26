var PageLogicObj={
	m_BookListTabDataGrid:"",
	m_AdmListTabDataGrid:"",
	m_DianosListICD:"",
	m_CanSave:"Y",
	m_PatPhoneFlag:"",
	m_PatLinkPhoneFlag:"",
	m_DiaStatusBox:"",
	m_SortBox:"",
	m_PatFRelation:"",
	LocWardCheckBox:"LocWard^LinkWard^AllWard",
	pageLoagFinish:"N",
	IsCellCheckFlag:false
}
/*	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird 文件地址
	 document.getElementsByTagName('head')[0].appendChild(script);
}*/
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
})
$(window).load(function() {
	//数据初始化,setTimeout不可去掉，会导致联系人关系和住址数据清空
	setTimeout(function (){
		PageHandle();
	},50)
	//$HUI.radio("#LocWard").setValue(true);
})
function Init(){
	//初始化Comb组件
	IntCombList();
}
function InitEvent(){
	//保存住院证
	$('#Save').click(SaveCon);
	//住院证打印
	$('#Print').click(Print);
	//住院证保存并打印
	$('#SaPrint').click(SaPrint);
	//患者切换
	$('#CreatNew').click(CreatNew);
	//住院证查询
	$('#BookListFind').click(BookListTabLoad);
	//就诊列表查询
	$('#AdmListFind').click(AdmListTabLoad);
	//医嘱录入
	$('#OrderLink').click(OrderLinkClick);
	//联系电话修改
	$('#PatPhone').blur(function(){
		PatPhoneOnblur("PatPhone");	
	});
	//联系人电话修改
	//$('#PatFPhone').blur(function(){
	//	PatPhoneOnblur("PatFPhone");	
	//});
	//日间手术申请
	$('#OpertionLink').click(OpenOpertionClick);
	$("#tt").tabs({
		onSelect:function(title,index){
			if (index==1) {
				if (PageLogicObj.m_AdmListTabDataGrid=="") {
					PageLogicObj.m_AdmListTabDataGrid=InitAdmListTabDataGrid();
					AdmListTabLoad();
				}
			}
		}
	})
	
}
function PageHandle(){
	//框架和事件初始化
	PageLogicObj.m_BookListTabDataGrid=InitBookListTabDataGrid();
	$("#InSdate").dateboxq('setValue',ServerObj.NowDate);
	//选择病区范围
	$HUI.radio("[name='WardAre']",{
       onChecked:function(e,value){
            //通过病区类型初始化病区
			InWardCombCreat()
        }
    });
    
    
    /*
	//初始化患者信息	
	IntPaMes();
	//初始化就诊信息
	IntAmdMes();
	//初始化诊断放大镜
	IntAdmDiadesc();
	//初始化住院证信息
	setTimeout(function(){IntBookMes()});
	setTimeout(function(){Find()});
	*/
	
	//按照患者信息进行初始化
	NewIntPatMesCreat()
	//初始化诊断放大镜
	IntAdmDiadesc();
	//查询
	setTimeout(function(){Find()});
	//初始化缓存
	InitCache();
	//全部加在完成
	PageLogicObj.pageLoagFinish="Y"	
}

function InitCache () {
	var hasCache = $.DHCDoc.hasCache();
	if (hasCache!=1) {
		$.DHCDoc.storageCache();
	}
}
function InitBookListTabDataGrid(){
	var Columns=[[ 
		{field:'NO',title:'序号',width:50},
		{field:'IPBookingNo',title:'住院证号',width:100,align:'left'},
		{field:'BName',title:'姓名',width:70,align:'left'},
		{field:'BStatu',title:'状态',width:50,align:'left'},
		{field:'BBDate',title:'预约日期',width:90},
		{field:'BBCTloc',title:'预约科室',width:100},   
		{field:'BBWard',title:'预约病区',width:100},  
		{field:'AdmInitStateDesc',title:'病情',width:60},    
		{field:'BBBed',title:'预约床位',width:100,hidden:true},
		{field:'BBCreaterUser',title:'创建人',width:100},
		{field:'BBCreaterDate',title:'创建日期',width:100},
		{field:'rjss',title:'是否日间手术',width:100},
		{field:'BPatID',title:'患者ID',width:100,hidden:true},
		{field:'BAmdID',title:'就诊ID',width:100,hidden:true},
		{field:'BBookID',title:'操作',width:50,
			formatter: function(value,row,index){
				var btn = '<a class="editcls" onclick="CancelIPBook(\'' + row["BBookID"] + '\')">'+$g("撤销")+'</a>';
				return btn;
			}
		}
    ]]
	var BookListTabDataGrid=$("#BookListTab").datagrid({
		fit : true,
		height:'100',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'BBookID',
		columns :Columns,
		onSelect:function(index, row){
			//选择住院证获取对应信息
			ServerObj.BookID=row["BBookID"];
			//初始化住院证信息
			IntBookMes();
		},onBeforeSelect:function(index, row){
			if (PageLogicObj.IsCellCheckFlag==true) return true;
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				ServerObj.BookID="";
				return false;
			}
		},onUnselect:function(index, row){
			ServerObj.BookID="";
			ClearBookMes();
			ClearAdmMes();	
		}
	}); 
	return BookListTabDataGrid;
}
function InitAdmListTabDataGrid(){
	var Columns=[[ 
		{field:'NO',title:'序号',width:50},
		{field:'AdmDate',title:'就诊日期',width:100,align:'left'}, 
		{field:'AdmLoc',title:'就诊科室',width:150},
		{field:'AdmMark',title:'就诊号别',width:150},
		{field:'AdmDoc',title:'接诊医生',width:100},
		{field:'AdmDias',title:'诊断',width:200},
		{field:'AdmID',title:'AdmID',width:100,hidden:true}
    ]]
	var AdmListTabDataGrid=$("#AdmListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'AdmID',
		columns :Columns,
		onSelect:function(index, row){
			var selBookRow=PageLogicObj.m_BookListTabDataGrid.datagrid('getSelected');
			if (selBookRow){
				var selBookIndex=PageLogicObj.m_BookListTabDataGrid.datagrid('getRowIndex',selBookRow);
				PageLogicObj.m_BookListTabDataGrid.datagrid('unselectRow',selBookIndex);
			}			
			PageLogicObj.m_CanSave="Y";
			//选择住院证获取对应信息
			ServerObj.BookID="";
			ServerObj.EpisodeID=row["AdmID"];
			//初始化住院证信息
			IntAmdMes()
		},onBeforeSelect:function(index, row){
			var oldSelRow=$(this).datagrid('getSelected');
			var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
			if (oldSelIndex==index){
				$(this).datagrid('unselectRow',index);
				ServerObj.BookID="";
				ServerObj.EpisodeID="";
				return false;
			}
			return true;
		}
	}); 
	return AdmListTabDataGrid;
}
function IntPaMes(){
	if (ServerObj.PatientID!=""){
		ClearPatMest()
		$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetPatDetail",
			PatientID:ServerObj.PatientID, PatientNO:"", AdmID:"",
			dataType:"text"
		},function(Patmes){
			var PatmesArry=Patmes.split("^");
			var PatID=PatmesArry[0];
			var PatNO=PatmesArry[1];
			var PatName=PatmesArry[2];
			var PatSex=PatmesArry[3];
			var PatBob=PatmesArry[4];
			var PatAge=PatmesArry[5];
			var PatGov=PatmesArry[6];
			var PatContry=PatmesArry[7];
			var PatProvince=PatmesArry[8];
			var PatCity=PatmesArry[9];
			var PatMarital=PatmesArry[10];
			var patNation=PatmesArry[11];
			var patPhone=PatmesArry[12];
			var patTel=PatmesArry[13];
			var patEducation=PatmesArry[14];
			var patWorkAddress=PatmesArry[15];
			var patCategoryDesc=PatmesArry[16];
			var patAddress=PatmesArry[17];
			var patMrNo=PatmesArry[18];
			var patSocial=PatmesArry[19];
			var patLinkName=PatmesArry[20];
			var patLinkPhone=PatmesArry[21];
			var patLinkRelation=PatmesArry[22];
			var patLinkRelationDr=PatmesArry[23];
			var patEmployeeFunction=PatmesArry[24];
			var patSecretLevel=PatmesArry[25];
			$("#PatNo").val(PatNO);
			$("#PatName").val(PatName);
			$("#PatSex").val(PatSex);
			$("#PatAge").val(PatAge);
			$("#PatMRNo").val(patMrNo);
			if (patTel!=""){
				$("#PatPhone").val(patTel);
			}else{
				$("#PatPhone").val(patPhone);
			}
			PageLogicObj.m_PatPhoneFlag=$("#PatPhone").val();
			$("#PatType").val(patSocial);
			$("#PatID").val(PatGov);
			$("#PatFName").val(patLinkName);
			$("#PatFPhone").val(patLinkPhone);
			PageLogicObj.m_PatLinkPhoneFlag = patLinkPhone;
			//$("#PatFRelation").val(patLinkRelation);
			PageLogicObj.m_PatFRelation.setValue(patLinkRelationDr);
			$("#PatCompany").val(patWorkAddress);
			$("#PatAddress").combobox('setText',patAddress); 
			
		})
	}
}
function IntAmdMes(){
	//获取诊断ID
	if (ServerObj.EpisodeID!=""){
		//判断就诊是否可以用来办理住院证
		if (ServerObj.IPBKFlag=="Booking"){
			var Rtn=$.cm({
				ClassName:"web.DHCDocIPBookNew",
				MethodName:"CheckBeforeSave",
				AdmID:ServerObj.EpisodeID, BookID:ServerObj.BookID, Type:1, Instring:"",
				dataType:"text"
			},false);
			if (Rtn!=0){
				var RtnArry=Rtn.split("^");
				//alert(RtnArry)
				if (RtnArry[0]=="-1"){
					$.messager.alert('提示',RtnArry[1],"info",function(){
						PageLogicObj.m_CanSave="N";
					});
					return false;
				}else{
					$.messager.alert('提示',RtnArry[1]);
				}
			}
		}
		var AdmICDList=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetAdmICDList",
			Adm:ServerObj.EpisodeID,
			dataType:"text"
		},false);
		PageLogicObj.m_DianosListICD=AdmICDList;
		IntDianosList();
		var PatAdmMes=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetPatAdmMes",
			AdmID:ServerObj.EpisodeID,
			dataType:"text"
		},false);
		if (PatAdmMes!=""){
			var PatAdmMesArry=PatAdmMes.split("^")
			if (PatAdmMesArry[5]!=ServerObj.PatientID){
				ServerObj.PatientID=PatAdmMesArry[5];
				IntPaMes();
			}
		}
	}
}
function IntCombList(){
	//入院病情
	AdmInitStateCombCreat()
	//诊断状态
	DiaStatusCombCreat()
	//当前状态
	InCurStatuCombCreat()
	//操作原因
	InReasonCombCreat()
	//入院途径
	InSorceCombCreat()
	//住院科室
	InCtlocCombCreat()
	//建议床位类型 
	InBedTypeCombCreat()
	//病人等级
	PatientLevelCreat()
	//收治原则
	TreatedPrincipleCreat()
	//排序
	SortCombCreat()
	//联系人关系
	PatFRelationCombCreat()
	// 家庭住址
	PatAddressCombCreat();
}
function IntBookMes(){
	if (ServerObj.BookID!=""){
		$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetBookMesage",
			BookID:ServerObj.BookID,
			dataType:"text"
		},function(BookMesag){
			if (BookMesag!=""){
				var ArryBookMesag=BookMesag.split("^")
				//按照住院证信息初始化界面信息
				if (ServerObj.PatientID!=ArryBookMesag[1]){
					ServerObj.PatientID=ArryBookMesag[1];
					IntPaMes();
				}
				if (ServerObj.EpisodeID!=ArryBookMesag[2]){
					ServerObj.EpisodeID=ArryBookMesag[2];
					IntAmdMes();
				}
				//按照住院证初始化诊断信息
				var DiagnoseStr=ArryBookMesag[36] ;
				var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2));
				var Legnt1=DiagnoseStrArry.length;
				var TemStr="";
				for (var i=0;i<Legnt1;i++){
					var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0];
					var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1];
					var SID=DiagnoseStrArry[i].split(String.fromCharCode(1))[2];
					var SIDesc=DiagnoseStrArry[i].split(String.fromCharCode(1))[3];
					var DiagnosCat=DiagnoseStrArry[i].split(String.fromCharCode(1))[4];
					if ((ID=="")&&(Desc=="")){continue};
					if (TemStr==""){
						TemStr=Desc+"^"+ID+"^"+SID+"^"+SIDesc+"^"+DiagnosCat;
					}else{
						TemStr=TemStr+"!"+Desc+"^"+ID+"^"+SID+"^"+SIDesc+"^"+DiagnosCat;
					}
				}
				//alert(ArryBookMesag[25])
				PageLogicObj.m_DianosListICD=TemStr;
				
				IntDianosList();
				//当前状态
				//若住院证是住院状态,则只能查看
				if (ArryBookMesag[8]==ServerObj.AdmissionRowid){
					//$("#InCurStatu").combobox('disable'); 
					$(".kw-section-list>li").addClass("disable-li");
					$(".hisui-linkbutton").hide();
					if (ServerObj.AllowPrintFlag=="1"){$("#Print").show(); }
				}
				var items=$("#InCurStatuKW").keywords('options').items;
				if ($.hisui.indexOfArray(items,"id",ArryBookMesag[8])<0) {
					items.push({"id":ArryBookMesag[8],"text":ArryBookMesag[25]});
					$("#InCurStatuKW").keywords({
					    singleSelect:true,
					    labelCls:'red',
					    items:items
					});
				}
				$("#InCurStatuKW").keywords('select',ArryBookMesag[8]);
				//$('#InCurStatu').combobox('setValue',ArryBookMesag[8]);
				//$('#InCurStatu').combobox('setText',ArryBookMesag[25]);
				
				//入院病情
				$('#AdmInitState').combobox('select',ArryBookMesag[20]);
				//操作原因
				$('#InReason').combobox('select',ArryBookMesag[21]);
				//入院途径
				$("#InSorce").combobox('select',ArryBookMesag[22]);
				//预交金
				$("#IPDeposit").val(ArryBookMesag[17])
				
				//备注
				$("#InResumeText").val(ArryBookMesag[15])
				
				//建议床位类型
				$("#InBedType").combobox('select',ArryBookMesag[23]);
				//预约日期
				$('#InSdate').dateboxq('setValue',ArryBookMesag[10]);
				//科室--先设置科室在设置病区
				$("#InCtloc").combobox('select',ArryBookMesag[13]);
				if (ArryBookMesag[25].indexOf("签床")>=0) {
					$("#InCtloc").combobox('disable')
				}
				setTimeout(function(){
					//设置病区选择区
					var WardType=ArryBookMesag[54];
					if (WardType>0){
						var LocWardCheckBoxArry=PageLogicObj.LocWardCheckBox.split("^")
						var WardTypeName=LocWardCheckBoxArry[WardType-1]
						if (WardTypeName!=""){
							$HUI.radio("#"+WardTypeName).setValue(true);
						}
					}
					
					//病区
					$("#InWard").combobox('select',ArryBookMesag[11]);
					//床位
					//$("#InBed").combobox('select',ArryBookMesag[12]);
					$("#PatientLevel").combobox('select',ArryBookMesag[40]);
					$("#CTLocMedUnit").combobox('select',ArryBookMesag[41]);
					$("#InDoctor").combobox('select',ArryBookMesag[42]);
				})
				$("#TreatedPrinciple").combobox('select',ArryBookMesag[43]);
				if(ArryBookMesag[51]=="Y"){
					$("#IsDayFlag").checkbox('setValue',true);	
				}else{
					$("#IsDayFlag").checkbox('setValue',false);		
				}
				if(ArryBookMesag[52]=="Y"){
					$("#IsOutTriage").checkbox('setValue',true);	
				}else{
					$("#IsOutTriage").checkbox('setValue',false);		
				}
				
				
			}
		})
	}
}
function Find(){
	BookListTabLoad();
	//AdmListTabLoad();
}
function BookListTabLoad(){
	if (ServerObj.IPBKFlag=="Booking"){
		//预约日期
		var FindBookDateF=$('#FindBookDateF').dateboxq('getValue');
		var FindBookDateN=$('#FindBookDateN').dateboxq('getValue');
		
		var SortNum = PageLogicObj.m_SortBox.getValue();
		$.cm({
		    ClassName : "web.DHCDocIPBookNew",
		    QueryName : "FindBookList",
		    PatID:ServerObj.PatientID, FindBookDateF:FindBookDateF, FindBookDateN:FindBookDateN,SortNum:SortNum,
		    Pagerows:PageLogicObj.m_BookListTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_BookListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		})
	}else{
		PageLogicObj.m_BookListTabDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	}
}
function AdmListTabLoad(){
	if (ServerObj.IPBKFlag=="Booking"){
		var AdmDateF=$('#AdmDateF').dateboxq('getValue');
		var AdmDateN=$('#AdmDateN').dateboxq('getValue');
		$.cm({
		    ClassName : "web.DHCDocIPBookNew",
		    QueryName : "FindAdmList",
		    PatID:ServerObj.PatientID, AdmDateF:AdmDateF, AdmDateN:AdmDateN,
		    Pagerows:PageLogicObj.m_AdmListTabDataGrid.datagrid("options").pageSize,rows:99999
		},function(GridData){
			PageLogicObj.m_AdmListTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		})
	}else{
		PageLogicObj.m_AdmListTabDataGrid.datagrid('loadData',{ 'total':'0',rows:[] });
	}
}
///诊断列表创建
function IntDianosList()
{
	$("#MRDiaList").empty();
	var panel=$("#MRDiaList");
	var InnerStr="";
	if (PageLogicObj.m_DianosListICD!=""){
		var DianosListArry=PageLogicObj.m_DianosListICD.split("!");
		for (var i=0;i<DianosListArry.length;i++){
			var Desc=DianosListArry[i].split("^")[0];
			var ICDDr=DianosListArry[i].split("^")[1];
			var StatusId=DianosListArry[i].split("^")[2];
			var StatusDesc=DianosListArry[i].split("^")[3];
			var DiagnosCat=DianosListArry[i].split("^")[4];
			var DiagosRowId=DianosListArry[i].split("^")[5];
			if (!DiagosRowId) DiagosRowId="";
			var SubDiagosRowIdStr=DianosListArry[i].split("^")[6];
			if (!SubDiagosRowIdStr) SubDiagosRowIdStr="";
			var Desc1=Desc
			if (StatusDesc!="") Desc1=Desc1+"("+StatusDesc+")";
			if (StatusId == "") StatusId="I-999"
			if (ICDDr=="undefined") continue;
			if (ICDDr=="") ICDDr=i+"_null";
			//<input name="ICDList" class="hisui-checkbox" id="16452" style="position: absolute; opacity: 0;" type="checkbox" data-options="checked:true" label="声嘶" descicd="声嘶" "=""></input>
			InnerStr=InnerStr+"<input DiagosRowId=\""+DiagosRowId+"\" SubDiagosRowIdStr=\""+SubDiagosRowIdStr+"\" diagnoscat=\""+DiagnosCat+"\" siddesc=\""+StatusDesc+"\" sid=\""+StatusId+"\" id=\""+ICDDr+"\" name=\""+"ICDList"+ "\" "+"\" DescICD=\""+Desc+ "\" class='hisui-checkbox' data-options='checked:true' type='checkbox' label='"+Desc1+"'>";
		}
	}
	panel.append(InnerStr);
	$HUI.checkbox($("input[name='ICDList']"),{onUnchecked:function(){DelDiangose()}});
}
function DelDiangose(){
	//去除列表中未选中的诊断
	var ObjInputs=$("input[name='ICDList']");
	var Str=""
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if (inputObj){
	        var DiagosRowId=inputObj.getAttribute("diagosRowid");
		    var SubDiagosRowIdStr=inputObj.getAttribute("subdiagosrowidstr");
	        if (inputObj.checked) {
		        var Desc=inputObj.getAttribute("DescICD");
		        var StatusId=inputObj.getAttribute("sid");
		        var siddesc=inputObj.getAttribute("siddesc");
		        var diagnoscat=inputObj.getAttribute("diagnoscat");
		        var ICD=inputObj.id;
		        if (Str==""){
			       Str=Desc+"^"+ICD+"^"+StatusId+"^"+siddesc+"^"+diagnoscat+"^"+DiagosRowId+"^"+SubDiagosRowIdStr;
			    }else{
				   Str=Str+"!"+Desc+"^"+ICD+"^"+StatusId+"^"+siddesc+"^"+diagnoscat+"^"+DiagosRowId+"^"+SubDiagosRowIdStr;
			    }
		    }else{
			    if (DiagosRowId!="") {
				    var SubDiagosRowIdStr=String.fromCharCode(1)+SubDiagosRowIdStr+String.fromCharCode(1);
				    for (var j=i+1;j<ObjInputs.length;j++){
					    var inputObj1=ObjInputs[j];
					    if (inputObj1) {
						    var DiagosRowId1=inputObj1.getAttribute("diagosRowid");
						    if ((DiagosRowId1!="")&&(SubDiagosRowIdStr.indexOf(String.fromCharCode(1)+DiagosRowId1+String.fromCharCode(1))>=0)){
								$(inputObj1).checkbox('setValue',false);
							}
						}
					}
				}
			}
	    } 
    }
    if (Str==""){
	    $.messager.alert('警告','请注意您当前临床诊断被清除为空,请及时选择!');   
	}
    //重新赋值
	PageLogicObj.m_DianosListICD=Str;
	IntDianosList();
}

function DiaStatusCombCreat() {
	PageLogicObj.m_DiaStatusBox = $HUI.combobox("#DiaStatus", {
		//url:$URL+"?ClassName=web.DHCDocIPBookNew&QueryName=QryDiaStatus&ResultSetType=array",
		valueField:'CombValue',
		textField:'CombDesc',
		blurValidValue:true,
		data: JSON.parse(ServerObj.DiaStatusPara),
		editable:false,
		onLoadSuccess: function () {
			var data = $(this).combobox('getData');
			$(this).combobox("select",data[0].CombValue);
		}
	});	
}
function AdmInitStateCombCreat(){
	/*$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"AdmInitState", Inpute1:"", Inpute2:"", Inpute3:"", Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},function(GridData){*/
		var cbox = $HUI.combobox("#AdmInitState", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				blurValidValue:true,
				editable:true,
				//data: GridData["rows"],
				data: JSON.parse(ServerObj.AdmInitStatePara),
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',"");
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$(this).combobox('select',"");
					}
				}
		 });
	//});
}
function InCurStatuCombCreat(){
	//根据IPBKFlag标志设置默认显示值
	/*DHCDocIPBDictoryCommonNew("InCurStatu",ServerObj.InCurStatuPara);
	if (ServerObj.LogonDoctorType != "DOCTOR") {
		$("#InCurStatu").combobox({disabled:true}); 
	}*/
	var selItemId="";
	var itemsArr=new Array();
	var InCurStatuArr=eval("("+ServerObj.InCurStatuPara+")");
	for (var i=0;i<InCurStatuArr.length;i++){
		var id=InCurStatuArr[i].CombValue;
		var text=InCurStatuArr[i].CombDesc;
		var selected=InCurStatuArr[i].selected;
		if (selected==1) selItemId=id;
		itemsArr.push({"id":id,"text":text});
	}
	$("#InCurStatuKW").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:itemsArr
	});
	if (selItemId) $("#InCurStatuKW").keywords('select',selItemId);
	if (ServerObj.LogonDoctorType != "DOCTOR") {
		$(".kw-section-list>li").addClass("disable-li");
	}
}
function InReasonCombCreat(){
	//根据IPBKFlag标志设置默认显示值
	/*var CodeDefault=""
	var DisplayCode=""
	if (ServerObj.IPBKFlag=="Booking"){
		CodeDefault="Admit"
		DisplayCode="Admit"
	}else{
		CodeDefault="Admit"
	}
	DHCDocIPBDictoryCommon("InReason","IPBookingStateChangeReason",CodeDefault,DisplayCode)*/
	DHCDocIPBDictoryCommonNew("InReason",ServerObj.InReasonPara);
}
//入院途径初始化
function InSorceCombCreat(){
	/*$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"InSorce", Inpute1:"", Inpute2:"", Inpute3:"", Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},function(GridData){*/
		var cbox = $HUI.combobox("#InSorce", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				data: JSON.parse(ServerObj.InSorcePara),
				editable:true,
				blurValidValue:true,
				//data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',"");
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$(this).combobox('select',"");
					}
				}
		 });
	//});
}
function InCtlocCombCreat(){
	/*$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"InCtloc", Inpute1:session['LOGON.CTLOCID'], Inpute2:"", Inpute3:"", Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},function(GridData){
		var defaultLoc=tkMakeServerCall("DHCDoc.DHCDocConfig.CommonFunction","GetDefaultIPBookLoc", session['LOGON.CTLOCID']);*/
		$("#InCtloc").combobox({
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				blurValidValue:true,
				//data: GridData["rows"],
				data: JSON.parse(ServerObj.InCTLocPara),
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0); 
				},onSelect: function(rec){
					if ((rec)&&(rec["CombValue"]!="")){
						//$("input[name='WardAre']:checked").radio('setValue',false);
						var PatSex = $("#PatSex").val();
						var Bol = (rec.CombDesc.indexOf("妇")>=0)||(rec.CombDesc.indexOf("产")>=0);
						var errMsg = "男性病人不允许开到【" + rec["CombDesc"]+"】"
						if (Bol&&(PatSex == "男")) {
							$.messager.alert("提示",errMsg,"info",function(){
								$("#InCtloc").combobox('setValue','').combobox('setText','').combobox('hidePanel');
								$('#InCtloc').next('span').find('input').focus();
							});
							return false;
						}
						var myrtn=$.cm({
							ClassName:"web.DHCOPAdmReg",
							MethodName:"CheckRegDeptAgeSex",
							ASRowId:"", PatientID:ServerObj.PatientID,LocRowid:rec["CombValue"],
							dataType:"text"
					    },false);
					    var Flag=myrtn.split(String.fromCharCode(2))[0];
						if (Flag!="0") {
							var msg="";
							var AllowSexDesc=myrtn.split(String.fromCharCode(2))[1];
							if (AllowSexDesc!="") msg="此科室支持性别【"+AllowSexDesc+"】";
							var AgeRange=myrtn.split(String.fromCharCode(2))[2];
							if (AgeRange!="") {
								if (msg=="") {msg="此科室支持年龄段:"+AgeRange;}else{msg=msg+","+"此科室支持年龄段【"+AgeRange+"】";}
							}
							$.messager.alert("提示","不允许选择【"+rec["CombDesc"]+"】,"+msg,"info",function(){
								$("#InCtloc").combobox('setValue','').combobox('setText','').combobox('hidePanel');
								$('#InCtloc').next('span').find('input').focus();
							});
							return false;
						}
						diaplayWardCheck(rec["CombValue"]);
						setTimeout(function(){
							//初始化病区
					        InWardCombCreat();
					        //初始化医疗单元
					        CTLocMedUnitCreat();
					        //初始化住院医师
					        InDoctorCreat();
						})
					 }
					
				},onLoadSuccess:function(){
					//当科室下拉框只有一条数据且为默认科室,不清空value直接select不会进入onselect事件
					$("#InCtloc").combobox('setValue',"").combobox('select',ServerObj.DefaultLocRowId);
					if (ServerObj.DefaultLocRowId=="") {
						$HUI.combobox($("#InWard,#CTLocMedUnit,#InDoctor"),{});
					}
				}/*,onChange:function(newValue,oldValue){
					if (newValue==""){
						//$("#InWard,#CTLocMedUnit").combobox('select','');
					}
				}*/
		 });
	//});
}
function CTLocMedUnitCreat()
{
	var LocId=$("#InCtloc").combobox('getValue');
	var GridData=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"CTLocMedUnit", Inpute1:LocId, Inpute2:"", Inpute3:"", Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#CTLocMedUnit", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			blurValidValue:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onSelect: function(rec){
				//选择医疗单元后初始化住院医师
				InDoctorCreat();
			},onLoadSuccess:function(){
				$(this).combobox('select',"");
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					$("#InDoctor,#CTLocMedUnit").combobox('select','');
					InDoctorCreat();
				}
			}
	 });
}
function InDoctorCreat()
{
	var LocId=$("#InCtloc").combobox('getValue');
	var CTLocMedUnit=$('#CTLocMedUnit').combobox('getValue');
	var GridData=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"InDoctor", Inpute1:LocId, Inpute2:CTLocMedUnit, Inpute3:"", Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#InDoctor", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			blurValidValue:true,
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				$(this).combobox('select',"");
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					$(this).combobox('select',"");
				}
			}
	 });
}
//病区Comb初始化
function InWardCombCreat()
{
	var WardFlag=WardSelectFind()
	var LocId=$("#InCtloc").combobox('getValue');
	if (LocId=="") {
		var GridData={"rows":[],"total":0,"curPage":1}
	}else{
		var GridData=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			QueryName:"CombListFind",
			CombName:"InWard", Inpute1:LocId, Inpute2:ServerObj.PatientID, Inpute3:WardFlag, Inpute4:"", Inpute5:"", Inpute6:"",
			rows:99999
		},false);
	}
	var cbox = $HUI.combobox("#InWard", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			blurValidValue:true,
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["Alias"].toUpperCase().indexOf(q.toUpperCase()) >= 0); 
			},onLoadSuccess:function(){
				var data=$("#InWard").combobox('getData');
				if ((LocId!="")&&(data.length>0)){
					$("#InWard").combobox('select',data[0]['CombValue']);
					 //根据选择病区改变住院证状态
					ChangeStatuByWard(data[0]['CombValue'])
				}
			},onChange:function(newValue,oldValue){
				if (newValue==""){
					$(this).combobox('setValue',"");
					ChangeStatuByWard('');
				}else{
					ChangeStatuByWard(newValue)
				}
			}
	 });
}
//建议床位类型初始化
function InBedTypeCombCreat(){
	/*var CodeDefault="01"
	var DisplayCode=""
	DHCDocIPBDictoryCommon("InBedType","IPBookingBedType",CodeDefault,DisplayCode)*/
	DHCDocIPBDictoryCommonNew("InBedType",ServerObj.InBedTypePara);
}
///病人等级初始化
function PatientLevelCreat(){
	/*var CodeDefault=""	
	var DisplayCode=""
	DHCDocIPBDictoryCommon("PatientLevel","IPBookingPatientLevel",CodeDefault,DisplayCode)*/
	DHCDocIPBDictoryCommonNew("PatientLevel",ServerObj.PatientLevelPara);
}
//收治原则初始化
function TreatedPrincipleCreat(){
	/*var CodeDefault=""
	var DisplayCode=""
	DHCDocIPBDictoryCommon("TreatedPrinciple","IPBookingTreatedPrinciple",CodeDefault,DisplayCode)*/
	DHCDocIPBDictoryCommonNew("TreatedPrinciple",ServerObj.TreatedPrinciplePara);
	$('#TreatedPrinciple').combobox({
		onSelect:function(rec){ 
			if (rec){ 
				IsDayFlagClick(rec.CombValue);
			}
		}
	});
}
///排序
function SortCombCreat() {
	PageLogicObj.m_SortBox = $HUI.combobox("#i-sort", {
		valueField:'id',
		blurValidValue:true,
		textField:'desc',
		data:[
			{id:"1",desc:"正序"},
			{id:"2",desc:"倒序"}
		]
	});	
}
///联系人关系
function PatFRelationCombCreat() {
	/*$.m({
		ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
		MethodName:"ReadBaseData",
		TabName:"CTRelation",
		QueryInfo:"^^^HUIJSON"
	},function(Data){*/
		PageLogicObj.m_PatFRelation = $HUI.combobox("#PatFRelation", {
				valueField: 'id',
				blurValidValue:true,
				textField: 'text', 
				editable:true,
				data: JSON.parse(ServerObj.DefaultRelationPara)
				//data: JSON.parse(Data)
		 });
	//});
}

///创建字典Comb公共方法
//DHCDocIPBDictoryCommon("InCurStatu","IPBookingState",CodeDefault,DisplayCode);
function DHCDocIPBDictoryCommon(ListName,CodeType,CodeDefault,DisplayCode){
	$.cm({
		ClassName:"web.DHCDocIPBookNew",
		QueryName:"CombListFind",
		CombName:"DHCDocIPBDictory", Inpute1:CodeType, Inpute2:CodeDefault, Inpute3:DisplayCode, Inpute4:"", Inpute5:"", Inpute6:"",
		rows:99999
	},function(GridData){
		if (ListName=="InCurStatu"){
			var editable=false;
		}else{
			var editable=true;
		}
		var cbox = $HUI.combobox("#"+ListName, {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:editable,
				blurValidValue:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					//if (CodeType=="IPBookingState") alert(CodeDefault);
					if (CodeDefault==""){
						$(this).combobox('select','');
					}else{
						var Find=0;
						for (var i=0;i<GridData["rows"].length;i++){
							if (GridData["rows"][i]["selected"]=="1"){
								Find=1;
								$(this).combobox('select',GridData["rows"][i]["CombValue"]);
								break;
							}
						}
						if (Find==0){
							$(this).combobox('select','');
						}
					}
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$(this).combobox('select',"");
					}
				}
		 });
	});
}
function DHCDocIPBDictoryCommonNew(ListName,data){
	data=JSON.parse(data);
	if (ListName=="InCurStatu"){
			var editable=false;
			var blurValidValue=false;
		}else{
			var editable=true;
			var blurValidValue=true;
		}
		var cbox = $HUI.combobox("#"+ListName, {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:editable,
				blurValidValue:blurValidValue,
				data: data,
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					var Find=0;
					for (var i=0;i<data.length;i++){
						if (data[i]["selected"]=="1"){
							Find=1;
							$(this).combobox('select',data[i]["CombValue"]);
							break;
						}
					}
					if (Find==0){
						$(this).combobox('select','');
					}
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$(this).combobox('select',"");
					}
				}
		 });
}
function SaPrint(){
	if (Save()){
		Print()
	}
}
function Print(){
	//打印XML模板
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocIPBookPrt");
	var MyPara="";
	var PDlime=String.fromCharCode(2);
	if (ServerObj.BookID==""){
		$.messager.alert('警告','缺少预约信息!');
		return false;
	}
	var BookMesag=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetBookMesage",
		BookID:ServerObj.BookID,
		dataType:"text"
	},false);
	if (BookMesag==""){
		$.messager.alert('警告','缺少预约信息!');
		return false;
	}
	var BookMesagArry=BookMesag.split("^");
	var PatID=BookMesagArry[1];
	var PatMes=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetPatDetail",
		PatientID:ServerObj.PatientID, PatientNO:"", AdmID:"",
		dataType:"text"
	},false);
	var PatMesArry=PatMes.split("^");
	//按照住院证初始化诊断信息
	var DiagnoseStr=BookMesagArry[36];
	var DiagnoseStrArry=DiagnoseStr.split(String.fromCharCode(2));
	var Legnt1=DiagnoseStrArry.length;
	var DiaS="";
	for (var i=0;i<Legnt1;i++){
		var Desc=DiagnoseStrArry[i].split(String.fromCharCode(1))[0]
		var ID=DiagnoseStrArry[i].split(String.fromCharCode(1))[1]
		if ((ID=="")&&(Desc=="")){continue}
		if (DiaS==""){DiaS=Desc}
		else{DiaS=DiaS+","+Desc}
	}
	//姓名 性别 年龄 登记号 社会地位 工作单位 住址 联系电话 联系人 关系 联系人电话 诊断
	//住院科室 住院天数（不用） 首诊医院（不用） 操作用户姓名 操作日期 预约日期
	MyPara=MyPara+"PatName"+PDlime+PatMesArry[2]+"^"+"PatSex"+PDlime+PatMesArry[3]+"^"+"PatAge"+PDlime+PatMesArry[5];
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatMesArry[1]+"^"+"PatStat"+PDlime+PatMesArry[19];
	MyPara=MyPara+"^"+"PatCom"+PDlime+PatMesArry[15]+"^"+"PatAdd"+PDlime+PatMesArry[17];
	MyPara=MyPara+"^"+"PatTel"+PDlime+PatMesArry[13];
	MyPara=MyPara+"^"+"PatContact"+PDlime+PatMesArry[20]+"^"+"PatRelation"+PDlime+PatMesArry[22];
	MyPara=MyPara+"^"+"PatReTel"+PDlime+PatMesArry[21]+"^"+"PatMR"+PDlime+DiaS;
	MyPara=MyPara+"^"+"PatInDep"+PDlime+BookMesagArry[30]+"^"+"PatInDays"+PDlime+"";
	MyPara=MyPara+"^"+"PatFirHos"+PDlime+""+"^"+"PatUserCode"+PDlime+session['LOGON.USERNAME'];
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"CreatDate"+PDlime+BookMesagArry[4];
	MyPara=MyPara+"^"+"BookDate"+PDlime+BookMesagArry[10];
	MyPara=MyPara+"^"+"Price"+PDlime+BookMesagArry[17];
	MyPara=MyPara+"^"+"StateIDDesc"+PDlime+BookMesagArry[25]; 
	MyPara=MyPara+"^"+"CreatUserDesc"+PDlime+BookMesagArry[26]; 
	MyPara=MyPara+"^"+"CreatDocIDDesc"+PDlime+BookMesagArry[27]; 
	MyPara=MyPara+"^"+"WardIdDesc"+PDlime+BookMesagArry[28]; 
	MyPara=MyPara+"^"+"BedDesc"+PDlime+BookMesagArry[29]; 
	MyPara=MyPara+"^"+"ICDDesc"+PDlime+BookMesagArry[31]; 
	MyPara=MyPara+"^"+"AdmInitStateDesc"+PDlime+BookMesagArry[32]; 
	MyPara=MyPara+"^"+"InReasnDesc"+PDlime+BookMesagArry[33]; 
	MyPara=MyPara+"^"+"InSourceDesc"+PDlime+BookMesagArry[34]; 
	MyPara=MyPara+"^"+"InBedTypeDesc"+PDlime+BookMesagArry[35]; 
	MyPara=MyPara+"^"+"ICDListStr"+PDlime+BookMesagArry[36]; 
	MyPara=MyPara+"^"+"UpdateUserDesc"+PDlime+BookMesagArry[37]; 
	MyPara=MyPara+"^"+"UpdateDate"+PDlime+BookMesagArry[38]; 
	MyPara=MyPara+"^"+"UpdateTime"+PDlime+BookMesagArry[39];
	MyPara=MyPara+"^"+"PatitnLevel"+PDlime+BookMesagArry[40]; 
	MyPara=MyPara+"^"+"CTLocMedUnit"+PDlime+BookMesagArry[41]; 
	MyPara=MyPara+"^"+"InDoctorDR"+PDlime+BookMesagArry[42]; 
	MyPara=MyPara+"^"+"TreatedPrinciple"+PDlime+BookMesagArry[43]; 
	MyPara=MyPara+"^"+"IPBookingNo"+PDlime+BookMesagArry[44]; 
	MyPara=MyPara+"^"+"PatitnLevelDesc"+PDlime+BookMesagArry[45]; 
	MyPara=MyPara+"^"+"CTLocMedUnitDesc"+PDlime+BookMesagArry[46]; 
	MyPara=MyPara+"^"+"InDoctorDesc"+PDlime+BookMesagArry[47]; 
	MyPara=MyPara+"^"+"TreatedPrincipleDesc"+PDlime+BookMesagArry[48]; 
	MyPara=MyPara+"^"+"HospDesc"+PDlime+BookMesagArry[49]; 
	MyPara=MyPara+"^"+"PatDate"+PDlime+BookMesagArry[50]; 
	//
	if (BookMesagArry[25]=="预住院"){
	MyPara=MyPara+"^"+"PreFlag"+PDlime+"预"; }
	//var myobj=document.getElementById("ClsBillPrint");
	//DHCP_PrintFunNew(myobj,MyPara,"");
	DHC_PrintByLodop(getLodop(),MyPara,"","","");
}
///切换患者
function CreatNew(){
	var src="doc.patlistquery.hui.csp"; //"websys.default.csp?WEBSYS.TCOMPONENT=DHCExamPatList";
	var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("BookCreat","患者切换", 1300, 600,"icon-change-loc","",$code,"");
}

//保存住院证
function Save()
{
	if (PageLogicObj.m_CanSave!="Y"){
		return false;
	}
	if (ServerObj.IPBKFlag!="Booking"){
		//非预约权限用户 BookID不能为空只能保存
		if (ServerObj.BookID==""){
			$.messager.alert('警告','住院证主索引不存在不能正常保存.');   
			return false
		}
	}
	//验证必填字段
	var isMustFill = $.DHCDoc.validateMustFill();
	if (!isMustFill) {
		return false;
	}
	
	//保存前对就诊审核-目前允许多张住院证 返回-2不判断
	var Rtn=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"CheckBeforeSave",
		AdmID:ServerObj.EpisodeID, BookID:ServerObj.BookID, Type:1, Instring:"",
		dataType:"text"
	},false);
	if (Rtn!=0){
		var RtnArry=Rtn.split("^")
		if (RtnArry[0]=="-1"){
			$.messager.alert('警告',RtnArry[1]);
			return false
		}
	}
	var PatPhone=$('#PatPhone').val();
	if (PatPhone!=""){
		if (!CheckTelOrMobile(PatPhone,"PatPhone","联系电话")) return false;
	}
	var PatFPhone=$('#PatFPhone').val();
	if (PatFPhone!=""){
		if (!CheckTelOrMobile(PatFPhone,"PatFPhone","联系人电话")) return false;
	}
	//住院证ID
	var BookID=ServerObj.BookID; 
	//患者ID
	var PatID=ServerObj.PatientID; 
	//就诊ID 门诊
	var PAAdmOP=ServerObj.EpisodeID; 
	//关联住院ID
	var PAAdmIP=ServerObj.EpisodeIDIP; 
	//创建日期
	var CreateDate="";
	//创建时间
	var CreateTime="";
	var CreaterUser=session['LOGON.USERID'];
	var CreaterDocIDUser=session['LOGON.USERID'];
	//住院证状态
	var InCurStatuObj=$("#InCurStatuKW").keywords('getSelected'); //getComValue("InCurStatu"); 
	var InCurStatu=InCurStatuObj[0].id;
	//住院证有效状态
	var BookActive="Y";
	//预约日期
	var InSdate=$('#InSdate').dateboxq('getValue'); 
	//病区
	var InWard=getComValue("InWard");
	//床位
	var InBed="" //$('#InBed').combobox('getValue'); 
	//科室
	var InCtloc=getComValue("InCtloc");
	//所有诊断ICD
	var ICDList=GetAllDia();
	//备注
	var InResumeText=$("#InResumeText").val().replace(/(^\s*)|(\s*$)/g,''); 
	//住院押金
	var IPDeposit=$("#IPDeposit").val().replace(/(^\s*)|(\s*$)/g,''); 
	//入院病情
	var AdmInitState=getComValue("AdmInitState");
	//操作原因
	var InReason=getComValue("InReason");
	//入院途径
	var InSorce=getComValue("InSorce");
	//建议床位类型
	var InBedType=getComValue("InBedType");
	//紧急条件（韶关）-新版不用
	var MRCCondtion=""; 
	//ICD诊断-新版不用
	var ICDCode="";
	//医疗单元
	var CTLocMedUnit=getComValue("CTLocMedUnit");
	//主治医师
	var InDoctor=getComValue("InDoctor");
	//患者等级
	var PatientLevel=getComValue("PatientLevel");
	//收治原则
	var TreatedPrinciple=getComValue("TreatedPrinciple");
	var IsDayFlag="";
	if($('#IsDayFlag').checkbox('getValue')) {
	    IsDayFlag="Y";
	}
	var IsOutTriage="";
	if($('#IsOutTriage').checkbox('getValue')) {
	    IsOutTriage="Y";
	}
	var LocLogOn=session['LOGON.CTLOCID'];
	//病区选择类型
	var WardFlag=WardSelectFind()
	
	//可操作的状态
	var CanDoStatu=GetCanDoBookCode()
	
	//-----------
	var InCurStatuObj=$("#InCurStatuKW").keywords('getSelected');
	var Flag=InCurStatuObj[0].id; //$("#InCurStatu").combobox('getValue');
	//组织信息
	var Instr=BookID+"^"+PatID+"^"+PAAdmOP+"^"+PAAdmIP+"^"+CreateDate+"^"+CreateTime+"^"+CreaterUser+"^"+CreaterDocIDUser;
	var Instr=Instr+"^"+InCurStatu+"^"+BookActive+"^"+InSdate+"^"+InWard+"^"+InBed+"^"+InCtloc;
	var Instr=Instr+"^"+ICDCode+"^"+InResumeText+"^"+""+"^"+IPDeposit+"^"+MRCCondtion;
	//----------新版增加
	var Instr=Instr+"^"+AdmInitState+"^"+InReason+"^"+InSorce+"^"+InBedType+"^"+ICDList;
	var Instr=Instr+"^"+CTLocMedUnit+"^"+InDoctor+"^"+PatientLevel+"^"+TreatedPrinciple;
	var Instr=Instr+"^"+IsDayFlag+"^"+IsOutTriage+"^"+WardFlag+"^"+LocLogOn;
	//保存前对单子审核
	var Rtn=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"CheckBeforeSave",
		AdmID:PAAdmOP, BookID:BookID, Type:2, Instring:Instr,CanDoStatu:CanDoStatu,
		dataType:"text"
	},false);
	if (Rtn!=0){
		var RtnArry=Rtn.split("^")
		if (RtnArry[0]=="-1"){
			$.messager.alert('警告',RtnArry[1]);
			return false
		}
	}
	//保存
	var rtn=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"SaveBookMeth",
		Instring:Instr,
		dataType:"text"
	},false);
	if ((rtn=="-100")&&(rtn<0)){
		 $.messager.alert('警告','住院证保存失败',rtn);
		 return false;
	}else{
		 ServerObj.BookID=rtn;
	    var BookMesag=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetBookMesage",
			BookID:ServerObj.BookID,
			dataType:"text"
		},false);
		var Statu=BookMesag.split("^")[53];
		if ((Statu=="Cancel")&&(ServerObj.IPBKFlag=="Booking")){
			 ServerObj.BookID="";
			 ClearBookMes();
		}
		SavePatInfo();
		$.messager.alert('提示','成功!','info',function(){
			//查询
			BookListTabLoad();
			if (PageLogicObj.m_AdmListTabDataGrid!="") {
				AdmListTabLoad();
			}
			//保存后自动打开
			OpenOpertion("Auto")
			return true;
		}); 
		return true;
	}
}
function SavePatInfo(){
	var PatPhone=$('#PatPhone').val();
	var PatFPhone=$('#PatFPhone').val();
	var PatFName=$("#PatFName").val();
	var PatAddress=$("#PatAddress").combobox('getText');
	var PatFRelation=getComValue("PatFRelation") //PageLogicObj.m_PatFRelation.getValue();
	var Para=PatPhone+"^"+PatFPhone+"^"+PatFName+"^"+PatFRelation
	//if(PatPhone!=PageLogicObj.m_PatPhoneFlag){
		var Rtn=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"SetPatPhoneByPatID",
			PatientID:ServerObj.PatientID, 
			Para:Para,
			Address:PatAddress,
			dataType:"text"
		},false);
		if(Rtn!=0){
			$.messager.alert("提示","患者信息修改失败");
		}
	//}
}
function GetAllDia(){
	//获取所有加载在界面上选中的诊断ICD
	var Str="";
	var ObjInputs=$("input[name='ICDList']");
    for(var i=0;i<ObjInputs.length;i++){
        var inputObj=ObjInputs[i];
        if ((inputObj)&&(inputObj.checked)){
	       var Desc=inputObj.getAttribute("DescICD")
	       var ICD=inputObj.id; 
	       var SID=inputObj.getAttribute("sid")
	       if (SID=="I-999") SID="";
	       var diagnoscat=inputObj.getAttribute("diagnoscat");
	       if (ICD.indexOf("_null")>=0) ICD="";
	       if (ICD==""){
		       ICD=""+String.fromCharCode(2)+Desc+String.fromCharCode(2)+SID+String.fromCharCode(2)+diagnoscat;
		   }else{
			   ICD=ICD+String.fromCharCode(2)+""+String.fromCharCode(2)+SID;
		   }
	       if (Str==""){
		       Str=ICD;
		   }else{
		       Str=Str+"!"+ICD;
		   }
	    } 
    }
    return Str
}
///录入院前医嘱
function OrderLinkClick(){
	if (ServerObj.BookID==""){
		$.messager.alert("提示","缺少预约信息!");
		return false
	}
	var url=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetOrderLink",
		BookID:ServerObj.BookID,
		dataType:"text"
	},false);
	if (url==""){
		$.messager.alert("提示","非预住院状态不能开医嘱!");
		return false
	}
	/*var winName="IPBookOrderWrite"; 
	var awidth=screen.availWidth/6*5.5; 
	var aheight=screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	var $code ="<iframe width='100%' height='99%' scrolling='auto' frameborder='0' src='"+url+"'></iframe>" ;
	createModalDialog("BookCreat","院前医嘱录入", awidth, aheight,"icon-w-edit","",$code,"");*/
	websys_showModal({
		url:url,
		title:'院前医嘱录入',
		width:'95%',height:'95%'
	});
}
//
function PatPhoneOnblur(id){
	var PatPhone=$("#"+id).val();
	var bol=false;
	if (id == "PatFPhone") {
		bol = (PatPhone != PageLogicObj.m_PatLinkPhoneFlag)
	} else {
		bol = (PatPhone != PageLogicObj.m_PatPhoneFlag)	
	}
	if(bol){
		if ((PatPhone=="")&&(id=="PatPhone")){
			$.messager.alert("提示","联系电话不能为空!","info",function(){
				$("#" + id).focus();
			});
			return false;
		}
		if (PatPhone.indexOf('-')>=0){
			var Phone=PatPhone.split("-")[0]
			var Phonearr=PatPhone.split("-")[1]
			if(Phone.length==3){
				if(Phonearr.length!=8){
					$.messager.alert("提示","固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
						$("#" + id).focus();
					});
		        	return false;
				}
			}else if(Phone.length==4){
				if(Phonearr.length!=7){
					$.messager.alert("提示","固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
						$("#" + id).focus();
					});
		        	return false;
				}
			}else{
				$.messager.alert("提示","不存在固定电话,请核实!","info",function(){
					$("#" + id).focus();
				});
	        	return false;
			}
		}else{
			if(PatPhone.length!=11){
				$.messager.alert("提示","电话长度应为【11】位,请核实!","info",function(){
					$("#" + id).focus();
				});
	        	return false;
			}
		}
	}
}
function ChangePerson(PAAdmNew,PatientIDNew){
	if (PAAdmNew!=""){
		PageLogicObj.m_CanSave="Y";
		ClearAll()
		ServerObj.EpisodeID=PAAdmNew;
		ServerObj.PatientID=PatientIDNew;
		ServerObj.BookID="";
		//初始化患者信息
		IntPaMes();
		//初始化就诊信息
		IntAmdMes();
		//初始化住院证信息
		IntBookMes();
		//初始化查询
		BookListTabLoad();
		if (PageLogicObj.m_AdmListTabDataGrid!="") {
			AdmListTabLoad();
		}
	}
}
//清除所有
function ClearAll(){
	ClearBookMes();
	ClearPatMest();
	ClearAdmMes();	
}
//清除住院证信息
function ClearBookMes(){
	$('#InCtloc,#InWard,#InSorce,#InBedType,#InReason,#AdmInitState,#PatientLevel,#InBedType,#TreatedPrinciple,#InBedType,#CTLocMedUnit,#InDoctor').combobox('select','');
	$('#InSdate').dateboxq('setValue',ServerObj.NowDate);
	$("#IPDeposit,#InResumeText").val("");
	$("#IsDayFlag,#IsOutTriage").checkbox('setValue',false);
	InReasonCombCreat();
	InBedTypeCombCreat();
}
//清除就诊诊断
function ClearAdmMes(){
	PageLogicObj.m_DianosListICD="";
	IntDianosList();
}
//清除患者基本信息
function ClearPatMest(){
	$("#PatNo,#PatName,#PatSex,#PatAge,#PatMRNo,#PatPhone,#PatType,#PatID,#PatFName,#PatFPhone,#PatCompany").val('');
	$("#PatAddress").combobox('setText','');
	if (PageLogicObj.m_PatFRelation!="") PageLogicObj.m_PatFRelation.setValue("")
	else $("#PatFRelation").val("");
}
function IntAdmDiadesc(){
	//诊断
	 $("#AdmDiadesc").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'desc',
        columns:[[  
            {field:'desc',title:'诊断名称',width:300,sortable:true},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCMRDiagnos',QueryName: 'LookUpWithAlias'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var DiaType="0"
			if ($HUI.checkbox("#DiaType").getValue()){
				DiaType="1";
			}
			param = $.extend(param,{desc:desc,ICDType:DiaType});
	    },onSelect:function(ind,item){
		    var DiaStatus=PageLogicObj.m_DiaStatusBox.getText();
		    var DiaStatusId=PageLogicObj.m_DiaStatusBox.getValue();
            var Desc=item['desc'];
            //if (DiaStatus!="") Desc = Desc + "(" + DiaStatus + ")";
			var ID=item['HIDDEN'];
			if (PageLogicObj.m_DianosListICD==""){
				PageLogicObj.m_DianosListICD=Desc+"^"+ID+"^"+DiaStatusId+"^"+DiaStatus+"^"+"";
			}else{
				PageLogicObj.m_DianosListICD=PageLogicObj.m_DianosListICD+"!"+Desc+"^"+ID+"^"+DiaStatusId+"^"+DiaStatus+"^"+"";
			}
			//选择之后直接创建到列表	
			IntDianosList();
			$HUI.lookup("#AdmDiadesc").clear();
			$HUI.lookup("#AdmDiadesc").hidePanel();
		}
    });
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function DocumentUnloadHandler(){
	if (ServerObj.IPBKFlag!="Booking"){
		if (window.opener){
			window.opener.location.reload();  
		}
	}
}
function getComValue(Item){
	var value=$("#"+Item).combobox('getValue');
	if ((value=="undefined")||(typeof(value)=="undefined")){
		return ""
	}
	return value;
	/*
	var newValue="";
	if (value!=""){
		var data=$("#"+Item).combobox('getData');
		for (var i=0;i<data.length;i++){
			var id=data[i]['CombValue'];
			if (value==id){
				newValue=id.split("^")[0];
				break;
			}
		}
	}
	return newValue;
	*/
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
function OpenOpertionClick(){
	OpenOpertion("Handel")
}
function SaveCon(){
	var DoFlag="Y"
	if (ServerObj.BookID!=""){
		var InCurStatuObj=$("#InCurStatuKW").keywords('getSelected');
		var InCurStatu=InCurStatuObj[0].id; //$('#InCurStatu').combobox('getValue'); //住院证状态
		var BookMesag=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetBookMesage",
			BookID:ServerObj.BookID,
			dataType:"text"
		},false)
		if (BookMesag!=""){
			var BookMesagArry=BookMesag.split("^");
			var diastr=$.cm({
				ClassName:"web.DHCDocIPBookNew",
				MethodName:"GetDHCDocIPBDictory",
				rowid:InCurStatu,
				dataType:"text"
			},false);
			var diastrArry=diastr.split("^");
			if ((BookMesagArry[8]!=InCurStatu)&&(("Register^SignBed").indexOf(BookMesagArry[53])>=0))
			{
				DoFlag="N"
				$.messager.confirm("确认","当前住院证状态为【"+BookMesagArry[25]+"】,将要更改为【"+diastrArry[1]+"】,是否继续保存？",function(r){
					if (r){
						Save()
					}
				})
				
			}
		}
	}
	if (DoFlag=="Y"){
		Save()
	}
}
function ChangeStatuByWard(WardDr){
	if (WardDr==undefined) WardDr="";
	if (ServerObj.BookID!=""){return}
	//选择病区 预入院病区自动改变状态到预入院
	var InpatWardFlag=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetWardPreInPatientFlag",
		rowid:WardDr,
		dataType:"text"
	},false);
	if (InpatWardFlag=="Y"){
		SetCurStatu("PreInPatient");
	}else{
		//SetCurStatu("Booking");
	}
	
}
//按照病区串得位置获取当前选中得病区类型
function WardSelectFind(){
	var checkedRadioJObj= $("input[name='WardAre']:checked");
	var WardFlag=""
	var CheckMutuallyArry=PageLogicObj.LocWardCheckBox.split("^")
	for (var i=0;i<CheckMutuallyArry.length;i++){
		if (CheckMutuallyArry[i]==checkedRadioJObj.val()){
			WardFlag=(i+1)
		}
	}
	return WardFlag
}
function diaplayWardCheck(inlocdr){
	//控制选中后显示CheckBox
	if (inlocdr!=""){
		//关联得其他病区
		var LinkWard=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetLinkWard",
			ctlocdr:inlocdr,
			dataType:"text"
		},false);
		if (LinkWard==""){
			$('#'+"C"+'LinkWard').hide();
			$HUI.radio("#LinkWard").setValue(false);
		}else{
			$('#'+"C"+'LinkWard').show();
		}
		//无限制标识
		var LocCureLimit=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetLocCureLimit",
			ctlocdr:inlocdr,
			dataType:"text"
		},false);
		
		if (LocCureLimit!="Y"){
			$('#'+"C"+'AllWard').hide();
			$HUI.radio("#AllWard").setValue(false);
		}else{
			$('#'+"C"+'AllWard').show();
		}
		setTimeout(function(){
			//未找到选中得默认选中第一个
			var WardFlag=WardSelectFind()
			if (WardFlag==""){
				$HUI.radio("#LocWard").setValue(true);
			}
		})
	}
}

//日间手术点击
function IsDayFlagClick(TreatedPrinciplevalue){
	if (TreatedPrinciplevalue==""){return}
	var diastr=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"GetDHCDocIPBDictory",
		rowid:TreatedPrinciplevalue,
		dataType:"text"
	},false);
	var diaarry=diastr.split("^")
	if(diaarry[0]=="DaySurg"){
		var findstatu="N"
		var dataobj=$("#InCurStatuKW").keywords('options').items; //$('#InCurStatu').combobox('getData');
	 	var datalength=dataobj.length;
	 	for (var i=0;i<datalength;i++){
			var statudr=dataobj[i].id;; //dataobj[i].CombValue;
			if (statudr==""){continue}
			var statustr=$.cm({
				ClassName:"web.DHCDocIPBookNew",
				MethodName:"GetDHCDocIPBDictory",
				rowid:statudr,
				dataType:"text"
			},false);
			var statustrarry=statustr.split("^")
			if (statustrarry[0]=="PreInPatient"){
				findstatu="Y";
			}
		}
		var InCurStatuObj=$("#InCurStatuKW").keywords('getSelected');
		if (InCurStatuObj[0].id==ServerObj.PreInPatRowid){ //$("#InCurStatu").combobox('getValue')
			findstatu="Y";
		}
		if ((findstatu=="N")&&(statustrarry[0]!="Cancel")){
			$.messager.alert('提示',"预住院状态不可用!");	
		}
		SetCurStatu("PreInPatient")
	}else{
		//SetCurStatu("Booking")
	}
}
function SetCurStatu(CurStatuCode){
	var dataobj=$("#InCurStatuKW").keywords('options').items; //$('#InCurStatu').combobox('getData');
 	var datalength=dataobj.length;
 	for (var i=0;i<datalength;i++){
		var statudr=dataobj[i].id; //dataobj[i].CombValue;
		if (statudr==""){continue}
		var statustr=$.cm({
			ClassName:"web.DHCDocIPBookNew",
			MethodName:"GetDHCDocIPBDictory",
			rowid:statudr,
			dataType:"text"
		},false);
		var statustrarry=statustr.split("^")
		if (statustrarry[0]==CurStatuCode){
			//$('#InCurStatu').combobox('setValue',statudr);
			$("#InCurStatuKW").keywords('select',statudr);
		}
	}
}
//打开日间手术ID
function OpenOpertion(OpeType)
{
	var Url="";
	var rtn=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"HavveActiveOpertion",
		BookID:ServerObj.BookID,
		dataType:"text"
	},false);
	var rtnArry=rtn.split("^")
	var rtnflag=rtnArry[0]
	if ((rtnflag==0)||(rtnflag==1)){
		if (OpeType=="Auto"){
			//自动模式下只有未申请的单子才打开
			if (rtnflag==0){
				var Url=$.cm({
					ClassName:"web.DHCDocIPBookNew",
					MethodName:"GetBookOpertion",
					BookDr:ServerObj.BookID,
					dataType:"text"
				},false);
			}
		}else{
			var Url=$.cm({
				ClassName:"web.DHCDocIPBookNew",
				MethodName:"GetBookOpertion",
				BookDr:ServerObj.BookID,
				dataType:"text"
			},false);
		}
	}else{
		//不符合条件的单子自动模式下不提示
		if (OpeType=="Auto"){return}
		$.messager.alert('提示',"不能进行手术申请:"+rtnArry[1]);	
		return
	}
	if (Url=="") return;
	//日间手术申请固定宽度
	var winName="OpenOpertion"; 
	var awidth=1260 //screen.availWidth/6*5; 
	var aheight=680 ;screen.availHeight/5*4; 
	var atop=(screen.availHeight - aheight)/2;
	var aleft=(screen.availWidth - awidth)/2;
	var param0="scrollbars=0,status=0,menubar=0,resizable=2,location=0"; 
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;
	win=window.open(Url,winName,params); 
	win.focus();
	
}

function GetCanDoBookCode(){
	//可操作的状态
	var CanDoStatu=""
	if (ServerObj.IPBKFlag=="Booking"){
		CanDoStatu=ServerObj.BookStr
	}
	else{
		CanDoStatu=ServerObj.OtherBookStr
	}
	return 	CanDoStatu
}
function PatAddressCombCreat(){
	var cbox = $HUI.combobox("#PatAddress", {
		width:385,
		valueField: 'provid',
		textField: 'provdesc', 
		editable:true,
		mode:"remote",
		delay:"500",
		url:$URL+"?ClassName=web.DHCBL.CTBASEIF.ICTCardRegLB&QueryName=admaddressNewlookup&rows=999999",
		onBeforeLoad:function(param){
			if (PageLogicObj.pageLoagFinish!="Y"){return false}
			var desc="";
			if (param['q']) {
				desc=param['q'];
			}
			param = $.extend(param,{desc:desc});
		},
		loadFilter:function(data){
		    return data['rows'];
		}/*
		keyHandler:{
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },
            up: function () {
	            var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
                //取得上一行
                for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i].provid==CurValue) {
						if (i>0) $(this).combobox("select",Data[i-1].provid);
						break;
					}
				}
             },
             down: function () {
              	var Data=$(this).combobox("getData");
				var CurValue=$(this).combobox("getValue");
                //取得下一行
                for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i].provid==CurValue) {
							if (i < Data.length-1) $(this).combobox("select",Data[i+1].provid);
							break;
						}
					}else{
						$(this).combobox("select",Data[0].provid);
						break;
					}
				}
            },
            enter: function () { 
                //选中后让下拉表格消失
                $(this).combogrid('hidePanel');
            },
            query:function(q){
				var GridData=$.cm({
					ClassName:"web.DHCBL.CTBASEIF.ICTCardRegLB",
					QueryName:"admaddressNewlookup",
					desc:q,
					rows:999999
				},false);
				$(this).combobox("loadData",GridData["rows"]);
				$(this).combobox('setText',q);
	        } 
		}*/
 	});
}
function CheckTelOrMobile(telephone,Name,Type){
	if (telephone.length==8) return true;
	if (DHCC_IsTelOrMobile(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,并以连接符【-】连接,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"固定电话长度错误,固定电话区号长度为【3】或【4】位,固定电话号码长度为【7】或【8】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("提示",Type+"电话长度应为【11】位,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("提示",Type+"不存在该号段的手机号,请核实!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}



//最新初始化方法
function NewIntPatMesCreat(){
	if (ServerObj.BookID!=""){
		setTimeout(function(){IntBookMes()});
	}else{
		if (ServerObj.IntPatDetail!="")
		{
			SetPatDetail(ServerObj.IntPatDetail)
		}
		if ((ServerObj.IntPatAdmCheck!="")&&(ServerObj.IntPatAdmCheck!=0)){
			var RtnArry=ServerObj.IntPatAdmCheck.split("^");
			if (RtnArry[0]=="-1"){
				
				//var rtn=dhcsys_alert(RtnArry[1])
				//PageLogicObj.m_CanSave="N";
				
				$.messager.alert('提示',RtnArry[1],"info",function(){
					PageLogicObj.m_CanSave="N";
				});
				
				return false;
			}else{
				//dhcsys_alert(RtnArry[1])
				$.messager.alert('提示',RtnArry[1]);
			}
		}
		
		if (ServerObj.IntAdmICDList!=""){
			PageLogicObj.m_DianosListICD=ServerObj.IntAdmICDList
			IntDianosList();
		}
	}
	function SetPatDetail(Patmes){
			var PatmesArry=Patmes.split("^");
			var PatID=PatmesArry[0];
			var PatNO=PatmesArry[1];
			var PatName=PatmesArry[2];
			var PatSex=PatmesArry[3];
			var PatBob=PatmesArry[4];
			var PatAge=PatmesArry[5];
			var PatGov=PatmesArry[6];
			var PatContry=PatmesArry[7];
			var PatProvince=PatmesArry[8];
			var PatCity=PatmesArry[9];
			var PatMarital=PatmesArry[10];
			var patNation=PatmesArry[11];
			var patPhone=PatmesArry[12];
			var patTel=PatmesArry[13];
			var patEducation=PatmesArry[14];
			var patWorkAddress=PatmesArry[15];
			var patCategoryDesc=PatmesArry[16];
			var patAddress=PatmesArry[17];
			var patMrNo=PatmesArry[18];
			var patSocial=PatmesArry[19];
			var patLinkName=PatmesArry[20];
			var patLinkPhone=PatmesArry[21];
			var patLinkRelation=PatmesArry[22];
			var patLinkRelationDr=PatmesArry[23];
			var patEmployeeFunction=PatmesArry[24];
			var patSecretLevel=PatmesArry[25];
			$("#PatNo").val(PatNO);
			$("#PatName").val(PatName);
			$("#PatSex").val(PatSex);
			$("#PatAge").val(PatAge);
			$("#PatMRNo").val(patMrNo);
			if (patTel!=""){
				$("#PatPhone").val(patTel);
			}else{
				$("#PatPhone").val(patPhone);
			}
			PageLogicObj.m_PatPhoneFlag=$("#PatPhone").val();
			$("#PatType").val(patSocial);
			$("#PatID").val(PatGov);
			$("#PatFName").val(patLinkName);
			$("#PatFPhone").val(patLinkPhone);
			PageLogicObj.m_PatLinkPhoneFlag = patLinkPhone;
			//$("#PatFRelation").val(patLinkRelation);
			PageLogicObj.m_PatFRelation.setValue(patLinkRelationDr);
			$("#PatCompany").val(patWorkAddress);
			$("#PatAddress").combobox('setText',patAddress); 
	}
	
}
//撤销住院证
function CancelIPBook(BookID){
	PageLogicObj.IsCellCheckFlag=true;
	setTimeout(function() {
		$("#InCurStatuKW").keywords('select',ServerObj.CancelBookState);
		SaveCon();
		PageLogicObj.IsCellCheckFlag=false;
    },1000);	
	/*
	var InstringArr=new Array();
	InstringArr[0]=BookID;
	InstringArr[6]=session['LOGON.USERID'];
	InstringArr[31]=session['LOGON.CTLOCID'];
	var rtn=$.cm({
		ClassName:"web.DHCDocIPBookNew",
		MethodName:"UpdateBook",
		Instring:InstringArr.join("^"),
		OperType:"Cancel",
		dataType:"text"
	},false);
	if ((rtn=="-100")&&(rtn<0)){
		 $.messager.alert('警告','撤销住院证保存失败：'+rtn);
		 return false;
	}else{
		ServerObj.BookID="";
		ClearBookMes();
		//查询
		BookListTabLoad();
	}
	*/
}
document.body.onbeforeunload = DocumentUnloadHandler;
