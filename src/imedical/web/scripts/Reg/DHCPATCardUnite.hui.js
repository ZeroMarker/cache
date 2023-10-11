var PageLogicObj={
	m_PatCardListDataGrid:"",
	m_CardToSaveTabDataGrid:"",
	dw:$(window).width()-20,
	dh:$(window).height()-100,
	NewPatientID:"",
}
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function Init(){
	PageLogicObj.m_PatCardListDataGrid=InitPatCardListDataGrid();
}
function InitEvent(){
	$("#BFind").click(RegReturnListTabDataGridLoad);
	$('#PatNo').keydown(PatNoKeydownHandler);
	
}
function PageHandle(){
}
function PatNoKeydownHandler(e){
	var key=websys_getKey(e);
	if(key==13){
		var PatNo=$('#PatNo').val();
		if (PatNo!='') {
			var RegNoLength=10;
			if ((PatNo.length<RegNoLength)&&(RegNoLength!=0)) {
				for (var i=(RegNoLength-PatNo.length-1); i>=0; i--) {
					PatNo="0"+PatNo;
				}
			}
		}
		$('#PatNo').val(PatNo);
		RegReturnListTabDataGridLoad();
	}
}
function SelectAll(){
	var rows=PageLogicObj.m_PatCardListDataGrid.datagrid("getRows");
	if (!rows) {
		return false;
	}
	
	if ($("#Select")[0].innerText.indexOf("取消全选")>=0){
		for (var i=0; i<rows.length; i++) {
			if (PageLogicObj.NewPatientID==rows[i].TPatientID) continue ;
			PlayPatCardUnShowAll(rows[i].TPatientID)
		}
	}
	else{
		if (PageLogicObj.NewPatientID==""){
			$.messager.alert("提示","请先选择合并到的卡信息！");
			return false;
		}
		for (var i=0; i<rows.length; i++) {
			if (PageLogicObj.NewPatientID==rows[i].TPatientID) continue ;
			PlayPatCardShowAll(rows[i].TPatientID)
		}
	}
	var icon="icon-all-unselect"
	var innerText="取消全选"
	if ($("#Select")[0].innerText.indexOf("取消全选")>=0){
		innerText="全选"
		icon="icon-all-select"
	}
	
	var innerHTML='<span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">'+innerText+'</span><span class="l-btn-icon '+icon+'">&nbsp;</span></span>'
	$("#Select")[0].innerHTML=innerHTML
	
}
function InitPatCardListDataGrid(){
	var toobar=[{
        text: '全选',
        iconCls: 'icon-all-select',
        id:"Select",
        handler: function() { 
        	SelectAll()
        }
    }];
	var Columns=[[ 
		{field:'TPatientID',hidden:true,title:''},
		{field:'TPapmiNo',title:'登记号',width:100},
		{field:'Name',title:'姓名',width:100},
		{field:'CardNO',title:'卡号',width:100},
		{field:'ActivedFlag',title:'卡状态',width:70},
		{field:'TSex',title:'性别',width:80},
		{field:'TBirthday',title:'出生日期',width:90},
		{field:'Ttelphone',title:'电话',width:100},
		{field:'CredNo',title:'证件号码',width:160},
		{field:'TInMedicareNo',title:'病历号',width:105},
		{field:'PlayPat',title:'操作',width:130,formatter:function(value,rec){ 
	             var btn = '<a class="editcls" id = "PlayPatOn' + rec.TPatientID +'" onclick="PlayPatCardOnShow(\'' + rec.TPatientID + '\')">被合并</a>';
				 if (rec.ActivedFlag=="正常") {
				 	btn = btn + '&nbsp;&nbsp;&nbsp;&nbsp;<a class="editcls" id = "PlayPatOff' + rec.TPatientID +'" onclick="PlayPatCardOffShow(\'' + rec.TPatientID + '\')">合并到</a>'
				 }
					return btn;
                }
         },
		{field:'AdmInfo',title:'就诊信息',width:100, formatter:function(value,rec){  
	            var btn = '<a class="editcls"  onclick="PatCardPayDetail(\'' + rec.TPatientID + '\',\'' +  "" + '\')">就诊信息</a>';
				return btn;
             }
        },
        {field:'IsInHos',title:'是否在院',width:105,
			styler: function(value,row,index){
				if (value == "是"){
					return 'background-color:red;color:white;';
				}
			}},
        {field:'HaveRegNum',title:'就诊次数',width:105},
        {field:'InHosNum',title:'住院次数',width:105},
        {field:'NeedRegNum',title:'待诊就诊数',width:105, formatter:function(value,rec){
	        	if (value>0){  
	            	var btn = '<a class="editcls"  onclick="PatCardPayDetail(\'' + rec.TPatientID + '\',\'' +  "Reg" + '\')">'+value+'</a>';
					return btn;
	        	}
	        	else {
		        	return value;
		        }
             },
             styler: function(value,row,index){
				if (value>0){
					return 'background-color:red;color:white;';
				}
			}
        },
        {field:'NeedAppNum',title:'待取预约数',width:105, formatter:function(value,rec){  
        		if (value>0){
	            	var btn = '<a class="editcls"  onclick="PatCardPayDetail(\'' + rec.TPatientID + '\',\'' +  "App" + '\')">'+value+'</a>';
					return btn;
        		}else {
		        	return value;
		        }
        	},styler: function(value,row,index){
				if (value>0){
					return 'background-color:red;color:white;';
				}
			}
        },
    ]]
	var PatCardListTabDataGrid=$("#PatCardListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'TPatientID',
		columns :Columns,
		toolbar:toobar,
		onSelect:function(index, row){
		},
		onRowContextMenu:function(e, index, row){
		}
	});
	PatCardListTabDataGrid.datagrid('loadData', { total: 0, rows: [] });  
	return PatCardListTabDataGrid;
	
}
function RegReturnListTabDataGridLoad(){
	PageLogicObj.m_PatCardListDataGrid.datagrid("uncheckAll");
	var PatNo=$("#PatNo").val();
	ExpStr="^"+session['LOGON.HOSPID']+"^"+""+"^0";
	if (PatNo!=""){
		if (PatNo.length<10) {
			for (var i=(10-PatNo.length-1); i>=0; i--) {
				PatNo="0"+PatNo;
			}
	    }
		ExpStr="^"+session['LOGON.HOSPID']+"^"+PatNo+"^0";
	}
	$.cm({
	    ClassName : "web.DHCCardSearch",
	    QueryName : "PatientCardQuery",
	    Name:$("#Name").val(),
	    IDCardNo:"", //身份证号
	    CardNo:$("#CardNo").val(),
	    CardStatus:"",
	    CardTypeID:"", //GetCardTypeRowId(),
	    SupportFlag:"",
	    CredNo:$("#CredNo").val(),
	    UseStatus:"",
	    BirthDay:$("#BirthDay").val(),
	    Telphone:"",
	    OutMedicareNo:"",
	    InMedicareNo:$("#InMedicareNo").val(),
	    //NewOutMedicareNo:"",
	    //NewInMedicareNo:"",
	    InsuranceNo:$("#InsuranceN").val(),
	    EmMedicare:"^Unite",
	    ExpStr:ExpStr,
	    Pagerows:PageLogicObj.m_PatCardListDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		$("#div_demo").empty();
		PageLogicObj.m_PatCardListDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		$("#PatNo").val(PatNo);
		PageLogicObj.NewPatientID=""
	}); 
}
function PlayPatCardOffShow(PatientID){
	if($("#"+PatientID).length>0){
		
		$("#PlayPatOff"+PatientID).css({"background-color": "","color":"#017bce"});
		$("#"+PatientID).remove();
		$("#PlayPatOn"+PatientID).css({"background-color": "","color":"#017bce"});
		$("#"+PatientID).remove();
		if (PageLogicObj.NewPatientID!=PatientID){
			$("#PlayPatOff"+PageLogicObj.NewPatientID).css({"background-color": "","color":"#017bce"});
			//$("#PlayPatOn"+PatientID).atrr("style","")
			$("#"+PageLogicObj.NewPatientID).remove();
			var PatientStr=$.cm({
						ClassName:"web.DHCPATCardUnite",
						MethodName:"GetPatInfoByPatientID",
						dataType:"text",
						papmiID:PatientID,
						inforType:"New"
					},false);
			if (PatientStr!=""){
				var PatientStr=eval(PatientStr)
				Changedemocsswidth("Add")
				$("#demoon").tmpl(PatientStr).appendTo('#div_demo');
				$("#PlayPatOff"+PatientID).css({"background-color": "#f16e57","color":"#fff"});
				PageLogicObj.NewPatientID=PatientID;
				$("#BSave").click(SaveClickHandler);
				$('#BFill').click(BFillClickHandler);
				$HUI.switchbox('#switch2',{
                    onText:'隐藏相同',
                    offText:'显示所有',
                    onClass:'primary',
                    offClass:'gray',
                    size:"small",
                    onSwitchChange:function(e,val){
                        HideSameswitche(val.value);
                    }
                })
                $("#switch2").css({"left": "5px"});  
                HideSameswitche(true);
                InitUnitReason();
			}	
		}else {
			PageLogicObj.NewPatientID=""	
		}
	}else{
		if (PageLogicObj.NewPatientID!=PatientID){
			$("#PlayPatOff"+PageLogicObj.NewPatientID).css({"background-color": "","color":"#017bce"});
			$("#"+PageLogicObj.NewPatientID).remove();
			Changedemocsswidth("remove")
		}else{
			PageLogicObj.NewPatientID=""
		}
		var PatientStr=$.cm({
			ClassName:"web.DHCPATCardUnite",
			MethodName:"GetPatInfoByPatientID",
			dataType:"text",
			papmiID:PatientID,
			inforType:"New"
		},false);
		if (PatientStr!=""){
			var PatientStr=eval(PatientStr)
			Changedemocsswidth("Add")
			$("#demoon").tmpl(PatientStr).appendTo('#div_demo');
			$("#PlayPatOff"+PatientID).css({"background-color": "#f16e57","color":"#fff"});
			PageLogicObj.NewPatientID=PatientID;
			$("#BSave").click(SaveClickHandler);
			$('#BFill').click(BFillClickHandler);
			$HUI.switchbox('#switch2',{
                    onText:'隐藏相同',
                    offText:'显示所有',
                    onClass:'primary',
                    offClass:'gray',
                    size:"small",
                    onSwitchChange:function(e,val){
                        HideSameswitche(val.value);
                    }
                })
            $("#switch2").css({"left": "5px"});  
            HideSameswitche(true);
            InitUnitReason();
		}	
	}	
}
function PlayPatCardUnShowAll(PatientID){
	
	if($("#"+PatientID).length>0){
		$("#PlayPatOn"+PatientID).css({"background-color": "","color":"#017bce"});
		$("#"+PatientID).remove();
		Changedemocsswidth("remove")
	}
	ReSettableWid()
	CheckShowFillBtn()
}
function PlayPatCardShowAll(PatientID){
	
	if($("#"+PatientID).length>0){
		
	}else{
		var PatientStr=$.cm({
			ClassName:"web.DHCPATCardUnite",
			MethodName:"GetPatInfoByPatientID",
			dataType:"text",
			papmiID:PatientID,
			inforType:"Old"
		},false);
		if (PatientStr!=""){
			var PatientStr=eval(PatientStr);
			var Amount=PatientStr[0].OldAmount;
			/*if ((Amount!="")&&(Amount!=0)){
				$.messager.alert("提示","被合并的账户不是空,不允许被合并");
				return false;
			}*/
			Changedemocsswidth("Addoff")
			//document.getElementById('demoinsertcard').style.cssText = 'overflow-x:scroll;height: '+($(window).height()-450) +"px;"
			$("#demo").tmpl(PatientStr).appendTo('#div_demo');
			$("#PlayPatOn"+PatientID).css({"background-color": "#2ab66a","color":"#fff"});
			$("[id='CopyOld']").click(function(e){CopyOldToNew(e);})
			$("[id='CancleOld']").click(function(e){CancleOld(e)});
			HideSameswitche(false);
			var val=$HUI.switchbox('#switch2').getValue();
			HideSameswitche(val);
		}	
	}
	ReSettableWid()
	CheckShowFillBtn()
	
}


function PlayPatCardOnShow(PatientID){
	if (PageLogicObj.NewPatientID==PatientID){
		$("#PlayPatOff"+PatientID).css({"background-color": "","color":"#017bce"});
		$("#"+PatientID).remove();
		PageLogicObj.NewPatientID=""
		Changedemocsswidth("remove")
	}
	if($("#"+PatientID).length>0){
		$("#PlayPatOn"+PatientID).css({"background-color": "","color":"#017bce"});
		$("#"+PatientID).remove();
		Changedemocsswidth("remove")
	}else{
		var PatientStr=$.cm({
			ClassName:"web.DHCPATCardUnite",
			MethodName:"GetPatInfoByPatientID",
			dataType:"text",
			papmiID:PatientID,
			inforType:"Old"
		},false);
		if (PatientStr!=""){
			var PatientStr=eval(PatientStr);
			var Amount=PatientStr[0].OldAmount;
			/*if ((Amount!="")&&(Amount!=0)){
				$.messager.alert("提示","被合并的账户不是空,不允许被合并");
				return false;
			}*/
			Changedemocsswidth("Addoff")
			//document.getElementById('demoinsertcard').style.cssText = 'overflow-x:scroll;height: '+($(window).height()-450) +"px;"
			$("#demo").tmpl(PatientStr).appendTo('#div_demo');
			$("#PlayPatOn"+PatientID).css({"background-color": "#2ab66a","color":"#fff"});
			$("[id='CopyOld']").click(function(e){CopyOldToNew(e);})
			$("[id='CancleOld']").click(function(e){CancleOld(e)});
			HideSameswitche(false);
			var val=$HUI.switchbox('#switch2').getValue();
			HideSameswitche(val);
			
		}	
	}
	if (PageLogicObj.NewPatientID!=""){
		ReSettableWid()
		CheckShowFillBtn()
	}
	
}
function Changedemocsswidth(type){
	var Number=0
	$("table").each(function(){
		//$("table").attr("id")
		var id=$(this).attr('id')
		if (id){
			if (!isNaN(id)){
				Number=Number+1
			}
		}
	})
	var Alreadywidth=Number*310
	if (type="Add"){
		var Alreadywidth=Alreadywidth+370
	}
	if (type="Addoff"){
		var Alreadywidth=Alreadywidth+310
	} 
	if (type="remove"){
	}
	if (PageLogicObj.dw>Alreadywidth){
		$('#democsss').width(PageLogicObj.dw-20); 
	}else{
		$('#democsss').width(Alreadywidth); 	
	}

}
function CopyOldToNew(e,Oldid){
	var AddAlert=""
	if ((typeof(Oldid) !="undefined")&&(Oldid!="")){
		var id=Oldid
		var value=$("#"+Oldid).val()
		AddAlert="，只填充空白信息，请手动修改！"
	}else {
		var value = $(e.target).parents("tr").children("td").eq(1).children().val(); ///.children("input").value();
		var id = $(e.target).parents("tr").children("td").eq(1).children().attr("id"); 
	}
	if (id=="OldIDCard"){
		var NewCredType=$("#NewCredType").val();
		if ((typeof(Oldid) !="undefined")&&(Oldid!="")){
			var OldCredType=$("#OldCredType").val();
		}else {
			var OldCredType=$(e.target).parents("tr").parents("tbody").find("tr").eq(8).children("td").eq(1).children().val();
		}
		if (OldCredType!=NewCredType){
			$.messager.alert("提示","证件类型不一致,证件号码不能复制"+AddAlert);
			return false;
		}
		if (NewCredType.indexOf("身份证")>=0){
			var myIsID=DHCWeb_IsIdCardNo(value);
			if (!myIsID){
				return false;
			}
		}
	}
	if (id=="OldForeignIDCard") {
		var NewCredType=$("#NewForeignCredType").val();
		if ((typeof(Oldid) !="undefined")&&(Oldid!="")){
			var OldCredType=$("#OldForeignCredType").val();
		}else {
			var OldCredType=$(e.target).parents("tr").parents("tbody").find("tr").eq(38).children("td").eq(1).children().val();
		}
		if (OldCredType!=NewCredType){
			$.messager.alert("提示","联系人证件类型不一致,联系人证件号码不能复制"+AddAlert);
			return false;
		}
		if (NewCredType.indexOf("身份证")>=0){
			var myIsID=DHCWeb_IsIdCardNo(value);
			if (!myIsID){
				return false;
			}
		}
	}
	if ((id.indexOf("City")>=0)){
		if (Parentid=="OldProvincehouse"){ Parentid="OldProvinceHouse"}
		else var Parentid=id.replace(/City/, "Province")
		var NewParentid=Parentid.replace(/Old/, "New")
		if ($("#"+NewParentid).val()!=$("#"+Parentid).val()){
			var CityDesc=""
			switch (id) 
			{ 
				case "OldCityHome":CityDesc="市(籍贯)"; 
				break; 
				case "OldCityBirth":CityDesc="市(出生)"; 
				break; 
				case "OldCity":CityDesc="市(现住)"; 
				break; 
				case "OldCityhouse":CityDesc="市(户口)"; 
				break; 
			}
			$.messager.alert("提示",CityDesc+"对应的省份不一致，请核实"+AddAlert);
			return false;
		}
	}
	if ((id.indexOf("Area")>=0)){
		if (Parentid=="OldCityHouse"){ Parentid="OldCityhouse"}
		else var Parentid=id.replace(/Area/, "City")
		var NewParentid=Parentid.replace(/Old/, "New")
		if ($("#"+NewParentid).val()!=$("#"+Parentid).val()){
			var AreaDesc=""
			switch (Parentid) 
			{ 
				case "OldCityHome": AreaDesc="县(籍贯)"; 
				break; 
				case "OldCityBirth": AreaDesc="县(出生)"; 
				break; 
				case "OldCity": AreaDesc="县(现住)"; 
				break; 
				case "OldCityhouse": AreaDesc="县(户口)"; 
				break; 
			}
			$.messager.alert("提示",AreaDesc+"对应的城市不一致，请核实"+AddAlert);
			return false;
		}

	}
	if ((id.indexOf("Street")>=0)){
		if (id=="OldStreetNow") var Parentid="OldArea"
		else var Parentid=id.replace(/Street/, "Area")
		var NewParentid=Parentid.replace(/Old/, "New")
		if ($("#"+NewParentid).val()!=$("#"+Parentid).val()){
			var StreetDesc=""
			switch (id) 
			{ 
				case "OldStreetHome": StreetDesc="街道(籍贯)"; 
				break; 
				case "OldStreetBirth": StreetDesc="街道(出生)"; 
				break; 
				case "OldStreet": StreetDesc="街道(现住)"; 
				break; 
				case "OldStreetHouse": StreetDesc="街道(户口)"; 
				break; 
			}
			$.messager.alert("提示",StreetDesc+"对应的县级不一致，请核实"+AddAlert);
			return false;
		}

	}
	var Newid=id.replace(/Old/, "New")
	if($("#"+Newid).length>0){
		$("#"+Newid).val(value)
	}
	return true;
}
function CancleOld(e){
	var PatientID =$(e.target).parents("tr").parents("table").attr("id"); 
	$("#"+PatientID).remove();
	$("#PlayPatOn"+PatientID).css({"background-color": "","color":"#017bce"});
	Changedemocsswidth("remove")
	//改变界面布局
	ReSettableWid()
	//判断是否显示一键填充按钮
	CheckShowFillBtn()
}
function SaveClickHandler(){
	var checkflag=CheckbeforeupDate();
	if (checkflag==false) return;
	$("#Card-dialog").dialog("open");
	PageLogicObj.m_CardToSaveTabDataGrid=CardToSaveTabGrid();
	CardToSaveTabDataGridLoad()
}
function CardToSaveTabGrid(){
	var toobar=[{
        text: '保存',
        iconCls: 'icon-save',
        handler: function() {UpdateclickHandle();}
    }];
	var Columns=[[
		{field:'Check',title:'选择',checkbox:'true',align:'center',width:70,auto:false}, 
		{field:'CardRowid',hidden:true,title:'Rowid'},
		{field:'PatientNo',title:'登记号',width:100},
		{field:'CardType',title:'卡类型',width:100},
		{field:'CardNo',title:'卡号',width:100},
		{field:'PatName',title:'姓名',width:100},
		{field:'PatSex',title:'性别',width:100}
    ]]
	var CardToSaveTabDataGrid=$("#CardToSaveTab").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : false,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'CardRowid',
		columns :Columns,
		toolbar:toobar
	}); 
	return CardToSaveTabDataGrid;
}
function CardToSaveTabDataGridLoad(){
	var PatStr=""
	$("table").each(function(){
		//$("table").attr("id")
		var id=$(this).attr('id')
		if (id){
			if (!isNaN(id)){
					if (PatStr==""){PatStr=id}else{PatStr=PatStr+"^"+id}
				}
			}
	})
	$.q({
	    ClassName : "web.DHCPATCardUnite",
	    QueryName : "FindPatientCard",
	    PatientStr:PatStr,
	    Pagerows:PageLogicObj.m_CardToSaveTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_CardToSaveTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function UpdateclickHandle(){
	var obj;
	var OldRegNo="",RegNo="",SelectCard="",Amount="";
	var OldPapmiID=""
	$("table").each(function(){
		//$("table").attr("id")
		var id=$(this).attr('id')
		if (id){
			if (!isNaN(id)){
				if (OldPapmiID==""){OldPapmiID=id}else{OldPapmiID=OldPapmiID+"^"+id}
			}
		}
	})
	var SelectCard=""
    var SelCardRowArr=PageLogicObj.m_CardToSaveTabDataGrid.datagrid('getSelections');
    for (var i=0;i<SelCardRowArr.length;i++){
	    if (SelectCard=="") SelectCard=SelCardRowArr[i].CardRowid
	    else SelectCard=SelectCard+"^"+SelCardRowArr[i].CardRowid
    }
    if (SelectCard==""){
	     $.messager.alert("提示","请至少选择一张卡进行合并")
		 return false;
	}
	var PapmiID=PageLogicObj.NewPatientID
	var Name=$("#NewName").val();
	var Sex=$("#NewSex").val();
	var Birth=$("#NewBirthDay").val();
	var ConfirmInfo="";
	
	var MedicalNo=$("#NewMedicalNo").val();
	var OldMedicalNo=$("#OldMedicalNo").val();
	if ((MedicalNo=="")&&(OldMedicalNo!="")) MedicalNo=OldMedicalNo;  //自动保存病案号
	var PatType=$("#NewPatType").val();
	PatType=PatType.split(";")[0];
	var YBCode=$("#NewYBCode").val();
	
	var CredType=GetElementValue("NewCredType","1");
	var Marital=GetElementValue("NewMarital","1");
	var Tel=GetElementValue("NewTel","0");
	var Mobile=GetElementValue("NewMobile","0");
	var MedicalUnionNo=GetElementValue("NewMedicalUnionNo","0");
	
	var Country=GetElementValue("NewCountry","1");
	var Nation=GetElementValue("NewNation","1");
	var ProvinceHome=GetElementValue("NewProvinceHome","1");
	var CityHome=GetElementValue("NewCityHome","1");
	var ProvinceBirth=GetElementValue("NewProvinceBirth","1");
	
	var CityBirth=GetElementValue("NewCityBirth","1");
	var AreaBirth=GetElementValue("NewAreaBirth","1");
	var CompanyPostCode=GetElementValue("NewCompanyPostCode","0");
	var ProvinceHouse=GetElementValue("NewProvinceHouse","1");
	var Cityhouse=GetElementValue("NewCityhouse","1");
	
	var AreaHouse=GetElementValue("NewAreaHouse","1");
	var PostCodeHouse=GetElementValue("NewPostCodeHouse","0");
	var Province=GetElementValue("NewProvince","1");
	var City=GetElementValue("NewCity","1");
	var Area=GetElementValue("NewArea","1");
	
	var Address=GetElementValue("NewAddress","0");
	var Zip=GetElementValue("NewZip","0");
	var Vocation=GetElementValue("NewVocation","1");
	var Company=GetElementValue("NewCompany","0");
	var OfficeTel=GetElementValue("NewOfficeTel","0");
	
	var ForeignName=GetElementValue("NewForeignName","0");
	var Relation=GetElementValue("NewRelation","1");
	var ForeignAddress=GetElementValue("NewForeignAddres","0");
	var ForeignPhone=GetElementValue("NewForeignPhone","0");
	var ForeignIDCard=GetElementValue("NewForeignIDCard","0");
	var PoliticalLevel=GetElementValue("NewPoliticalLevel","1");
	var SecretLevel=GetElementValue("NewSecretLevel","1");
	var IDCard=GetElementValue("NewIDCard","0"); //证件号码
	var StreetNow=GetElementValue("NewStreetNow","1");
	var StreetBirth=GetElementValue("NewStreetBirth","1");
	var StreetHouse=GetElementValue("NewStreetHouse","1");
    var AreaHome = GetElementValue("NewAreaHome", "1");
    
    var RegisterPlace = $("#NewRegisterPlace").val(); 
    var AddressBirth = $("#NewAddressBirth").val() 
	if (CredType.indexOf("身份证")>=0) {
		var myIsID=DHCWeb_IsIdCardNo(IDCard);
		if (!myIsID){
			return false;
		}
		var IDNoInfoStr=DHCWeb_GetInfoFromId(IDCard)
		var IDBirthday=IDNoInfoStr[2]  
		if (Birth!=IDBirthday){
			$.messager.alert("提示","出生日期与身份证信息不符!");
   		    return false;
		}
		var IDSex=IDNoInfoStr[3]
		if(Sex!=IDSex){
			$.messager.alert("提示","身份证号:"+myIDNo+"对应的性别是【"+IDSex+"】,请核实性别信息!");
			return false;
		}
	}
	var ForeignCredType=GetElementValue("NewForeignCredType","1"); //联系人证件类型
	var UnitReason=$('#UnitReason').val();
	var OtherInfo=MedicalNo+"^"+PatType+"^"+YBCode;
	OtherInfo=OtherInfo+"^"+CredType+"^"+Marital+"^"+Tel+"^"+Mobile+"^"+MedicalUnionNo+"^"+Country+"^"+Nation
	OtherInfo=OtherInfo+"^"+ProvinceHome+"^"+CityHome+"^"+ProvinceBirth+"^"+CityBirth+"^"+AreaBirth+"^"+CompanyPostCode+"^"+ProvinceHouse
	OtherInfo=OtherInfo+"^"+Cityhouse+"^"+AreaHouse+"^"+PostCodeHouse+"^"+Province+"^"+City+"^"+Area+"^"+Address
	OtherInfo=OtherInfo+"^"+Zip+"^"+Vocation+"^"+Company+"^"+OfficeTel+"^"+ForeignName+"^"+Relation+"^"+ForeignAddress
	OtherInfo=OtherInfo+"^"+ForeignPhone+"^"+ForeignIDCard+"^"+PoliticalLevel+"^"+SecretLevel+"^"+IDCard+"^"+ForeignCredType;
    OtherInfo = OtherInfo + "^" + StreetNow + "^" + StreetBirth + "^" + StreetHouse + "^" + AreaHome + "^" + AddressBirth + "^" + RegisterPlace
	var flag=$.cm({
		ClassName:"web.DHCPATCardUnite",
		MethodName:"CardUniteNew",
		dataType:"text",
		OldPapmiIDStr:OldPapmiID,
		PapmiID:PapmiID,
		SelectCard:SelectCard,
		OtherInfo:OtherInfo,
		LogonHospDR:session['LOGON.HOSPID'],
		UnitReason:UnitReason,
		ComputerIP:ClientIPAddress
	},false);
	if (flag!=""){
		 $.messager.alert("提示","更新失败,错误信息为:"+flag);
		return false;
	}else{
		 $.messager.alert("提示","调整卡信息完成","",function(){
			 $("#Card-dialog").dialog("close");
			 location.reload();
			 
		});
		
	}
}
function GetElementValue(ElementName,DRFlag)
{
	ElementValue=$("#"+ElementName).val();
	if (DRFlag=="1") ElementValue=ElementValue.split(";")[0];
	return ElementValue;
}
function CheckbeforeupDate(){
	var OldPapmiID=""
	var PapmiID=PageLogicObj.NewPatientID
	$("table").each(function(){
		//$("table").attr("id")
		var id=$(this).attr('id')
		if (id){
			if (!isNaN(id)){
				if (OldPapmiID==""){OldPapmiID=id}else{OldPapmiID=OldPapmiID+"^"+id}
			}
		}
	})
	if (PapmiID==OldPapmiID){
		 $.messager.alert("提示","请选择被合并的卡");
		 return false
	}
	var CredType=GetElementValue("NewCredType","1");
	var Sex=$("#NewSex").val();
	var Birth=$("#NewBirthDay").val();
	var IDCard=GetElementValue("NewIDCard","0"); //证件号码
	if ((IDCard!="")&&(CredType.indexOf("身份证")>=0)) {
		var myIsID=DHCWeb_IsIdCardNo(IDCard);
		if (!myIsID){
			return false;
		}
		var IDNoInfoStr=DHCWeb_GetInfoFromId(IDCard)
		var IDBirthday=IDNoInfoStr[2]  
		if (Birth!=IDBirthday){
			$.messager.alert("提示","出生日期与身份证信息不符!");
   		    return false;
		}
		var IDSex=IDNoInfoStr[3]
		if(Sex!=IDSex){
			$.messager.alert("提示","身份证号:"+myIDNo+"对应的性别是【"+IDSex+"】,请核实性别信息!");
			return false;
		}
	}
	var flag=$.cm({
		ClassName:"web.DHCPATCardUnite",
		MethodName:"CheckforCardUniteNew",
		dataType:"text",
		OldPapmiIDStr:OldPapmiID,
		PapmiID:PapmiID
	},false);
	if (flag!=""){
		$.messager.alert("提示",flag)
		 return false
	}
	return true;
}
function PatCardPayDetail(PatientID,Code){
	var src="reg.dhcpatcardunitenopaydetail.hui.csp?PatientID="+PatientID+"&Code="+Code;
    src=('undefined'!==typeof websys_writeMWToken)?websys_writeMWToken(src):src;
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	var title="就诊信息明细"
	if (Code=="Reg"){
		var title="待诊就诊信息明细"
	}
	if (Code=="App"){
		var title="待取预约信息明细"
	}
	createModalDialog("Project",title, 1100, 620,"icon-w-list","",$code,"");
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
///
function HideSameswitche(value){
	if (value==true){
		HideEmi("OldMarital")
		HideEmi("OldTel")
		HideEmi("OldMobile")
		HideEmi("OldMedicalUnionNo")
		HideEmi("OldCredType")
		HideEmi("OldIDCard")
		HideEmi("OldYBCode")
		HideEmi("OldMedicalNo")
		HideEmi("OldPatType")
		HideEmi("OldCountry")
		HideEmi("OldNation")
		HideEmi("OldProvinceHome")
		HideEmi("OldCityHome")
        HideEmi("OldAreaHome")
		HideEmi("OldProvinceBirth")
		HideEmi("OldCityBirth")
		HideEmi("OldAreaBirth")
		HideEmi("OldProvince")
		HideEmi("OldCity")
		HideEmi("OldArea")
		HideEmi("OldAddress")
		HideEmi("OldZip")
		HideEmi("OldVocation")
		HideEmi("OldCompany")
		HideEmi("OldOfficeTel")
		HideEmi("OldCompanyPostCode")
		HideEmi("OldProvinceHouse")
		HideEmi("OldCityhouse")
		HideEmi("OldAreaHouse")
		HideEmi("OldPostCodeHouse")
		HideEmi("OldForeignName")
		HideEmi("OldRelation")
		HideEmi("OldForeignAddres")
		HideEmi("OldForeignPhone")
		HideEmi("OldForeignIDCard")
		HideEmi("OldPoliticalLevel")
		HideEmi("OldSecretLevel")
		HideEmi("OldForeignCredType")
		HideEmi("OldStreetNow")
		HideEmi("OldStreetBirth")
		HideEmi("OldStreetHouse")
		HideEmi("OldAddressBirth")
		HideEmi("OldRegisterPlace")
	}else{
		ShowEmi("OldMarital")
		ShowEmi("OldTel")
		ShowEmi("OldMobile")
		ShowEmi("OldMedicalUnionNo")
		ShowEmi("OldCredType")
		ShowEmi("OldIDCard")
		ShowEmi("OldYBCode")
		ShowEmi("OldMedicalNo")
		ShowEmi("OldPatType")
		ShowEmi("OldCountry")
		ShowEmi("OldNation")
		ShowEmi("OldProvinceHome")
		ShowEmi("OldCityHome")
        ShowEmi("OldAreaHome")
		ShowEmi("OldProvinceBirth")
		ShowEmi("OldCityBirth")
		ShowEmi("OldAreaBirth")
		ShowEmi("OldProvince")
		ShowEmi("OldCity")
		ShowEmi("OldArea")
		ShowEmi("OldAddress")
		ShowEmi("OldZip")
		ShowEmi("OldVocation")
		ShowEmi("OldCompany")
		ShowEmi("OldOfficeTel")
		ShowEmi("OldCompanyPostCode")
		ShowEmi("OldProvinceHouse")
		ShowEmi("OldCityhouse")
		ShowEmi("OldAreaHouse")
		ShowEmi("OldPostCodeHouse")
		ShowEmi("OldForeignName")
		ShowEmi("OldRelation")
		ShowEmi("OldForeignAddres")
		ShowEmi("OldForeignPhone")
		ShowEmi("OldForeignIDCard")
		ShowEmi("OldPoliticalLevel")
		ShowEmi("OldSecretLevel")
		ShowEmi("OldForeignCredType")
		ShowEmi("OldStreetNow")
		ShowEmi("OldStreetBirth")
		ShowEmi("OldStreetHouse")
		ShowEmi("OldAddressBirth")
		ShowEmi("OldRegisterPlace")
	}
}
function HideEmi(Oldid){
	var Newid=Oldid.replace(/Old/, "New")
	var Newval=$("#"+Newid).val();
	var Sameflag=0
	$('[id='+Oldid+']').each(function(){ 
		if ($(this).val()!=Newval){Sameflag=1} 
     });
     if (Sameflag==0){
	     $('[id='+Oldid+']').each(function(){ 
		if ($(this).val()!=Newval){Sameflag=1}
	            $(this).parents("tr").hide();
	            
	     });
	     $("#"+Newid).parents("tr").hide();
	 }
 }
function ShowEmi(Oldid){
	var Newid=Oldid.replace(/Old/, "New")
	$("#"+Newid).parents("tr").show();
	 $('[id='+Oldid+']').each(function(){ 
	           $(this).parents("tr").show();
	            
	     });
	}

function InitUnitReason(){
	$("#UnitReason").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'名称',width:250,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:300,
        panelHeight:370,
        isCombo:true,
        minQueryLen:0,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"患者主索引字典",DDesc:"卡合并原因"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#PrescNotes").val(item.Desc);
		}
    });
	ReSettableWid()
	CheckShowFillBtn()
}
function ReSettableWid(){
	if ($(".search-table").length>3){
		$("#Unittd")[0].style="padding-left:20px"
	}
	else{
		if ($(window).width()>1200){
			$("#Unittd")[0].style="padding-left:260px"
		}
		if ($(window).width()<1200){
			$("#Unittd")[0].style="padding-left:170px"
		}
	}
}
///获取被合并的patientid串
function GetOldPapmiIDStr(){
	var OldPapmiID=""
	var PapmiID=PageLogicObj.NewPatientID
	$("table").each(function(){
		//$("table").attr("id")
		var id=$(this).attr('id')
		if (id){
			if ((!isNaN(id))&&(PapmiID!=id)){
				if (OldPapmiID==""){OldPapmiID=id}else{OldPapmiID=OldPapmiID+"^"+id}
			}
		}
	})
	return OldPapmiID
}
function CheckShowFillBtn(){
	//注册配置->全局配置->卡合并自动填充为空的信息
	if (ServerObj.AutoFillUnitInfo!="Y"){
		$('#BFill').hide()
		return ;
	}
	var OldPapmiID=""
	var PapmiID=PageLogicObj.NewPatientID
	var OldPapmiID=GetOldPapmiIDStr()
	//不满足条件隐藏一键合并按钮
	//1.多个被合并的患者不允许一键合并；2.未选择被合并信息不显示。
	if ((OldPapmiID.indexOf("^")>=0)||(OldPapmiID=="")){
		$('#BFill').hide()
	}else {
		if (PapmiID==OldPapmiID){
			$('#BFill').hide()
	   	}else{
			$('#BFill').show()
		}
	}
}
function BFillClickHandler(){
	var FillStr="Marital^Tel^Mobile^MedicalUnionNo^CredType^IDCard^YBCode^MedicalNo^PatType^Country^Nation^ProvinceHome^CityHome^AreaHome^ProvinceBirth^CityBirth^AreaBirth^Province^City^Area^Address^Zip^Vocation^Company^OfficeTel^CompanyPostCode^ProvinceHouse^Cityhouse^AreaHouse^PostCodeHouse^ForeignName^Relation^ForeignAddres^ForeignPhone^ForeignIDCard^PoliticalLevel^SecretLevel^ForeignCredType^StreetNow^StreetBirth^StreetHouse^AddressBirth^RegisterPlace"
	var FillStrArr=FillStr.split("^")
	for(var i = 0; i < FillStrArr.length; i++) {
        var item=FillStrArr[i]
		var Newval=$("#New"+item).val();
		if (Newval!="") continue;
		var Oldval=$("#Old"+item).val();
		if (Oldval=="") continue;
		if (!CopyOldToNew("","Old"+item)) break;
		//不符合合并的条件时直接退出，防止无限弹窗不友好
      }
 }
 function ShowFillPopover(that) {
    var content = "填充“被合并”患者的信息到“合并到”患者的空白信息；选择多个被合并的患者信息不使用一键合并！"
    
    $(that).webuiPopover({
        title: '',
        content: content,
        trigger: 'hover',
        //style:'inverse',
		placement: "bottom",
		width:"220px",
        height: 'auto'

    });
    $(that).webuiPopover('show');
}
