//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
    $.parser.parse(); // 解析整个页面 
    var HospID=session['DHCMA.HOSPID']
	obj.HospID=HospID
	$('#winConfirmInfo').dialog({
		title: '入单病种管理【信息录入】',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true,	
		height: 400
	})
    $HUI.combobox('#Hospital',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=Array&aHospID='+HospID,
			valueField:'OID',
			textField:'Desc',
	    	onSelect:function(rd){
		    	HospID=rd.OID;
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aType=E&aAdmType=I';
        		$('#DishLoc').combobox('setValue','');
        		$('#DishLoc').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('Hospital',HospID);
			   }		    
	    } )	
    $HUI.combobox('#DishLoc',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aType=E&aAdmType=I',
			valueField:'OID',
			textField:'Desc'		    
	    })	
	 if ((tDHCMedMenuOper['admin'])||(tDHCMedMenuOper['HosAdmin']))
	 {}
	 else {
		Common_SetValue('DishLoc',session['DHCMA.CTLOCID']);
		$("#DishLoc").combobox('disable'); 
		$("#Hospital").combobox('disable'); 
	 }
	 if (session['DHCMA.CTLOCID']==undefined) {
			var InLocID=session['LOGON.CTLOCID']
		}else{
			var InLocID=session['DHCMA.CTLOCID']
	}	
	obj.gridQCMrList = $HUI.datagrid("#gridQCMrList",{
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		striped:true,
		rownumbers:true, 
		pageSize: 10,
		pageList : [10,50],
	    url:$URL,
	    nowrap:false,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
			QueryName:"QryPatientByDate"	
	    },
		columns:[[
			{field:'AdmLocDesc',title:'科室',width:120,align:'left'},
			{field:'MrNo',title:'病案号',width:80,align:'left'},
			{field:'PatName',title:'患者姓名',width:80,sortable:false,align:'left'},
			{field:'AdmDate',title:'入院日期',width:100,sortable:true,align:'left'},
			{field:'DisDate',title:'出院日期',width:100,sortable:true,align:'left'},		
			{field:'EpisodeID',title:'住院病历',width:90,align:'left',sortable:true,
				formatter: function(value,rd,index){
						var paadm=rd.EpisodeID.split('!!')[0]
						var patientID=rd.PatientID
						return " <a href='#' class='hisui-linkbutton hover-dark' style='cursor:pointer' onclick='objScreen.DisplayEPRView(\"" + paadm + "\",\"" + patientID + "\");'>"+$g('病历浏览')+"</a>";
				}
			},
			{field:'MrListID',title:'表单状态',width:100,sortable:true,align:'left',
				formatter: function(value,rd,index){
					if (rd.MrListID) {
						var rdModal=JSON.stringify(rd)
						if (rd.QCCurrStatus.indexOf("排除")<0) {
							return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.layer('+index+')>'+$g(rd.QCCurrStatus)+'</a>';
						}else{
							return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.InSDManager('+index+')>'+$g("排除再入组")+'</a>';	
						}
					}else{
						var rdModal=JSON.stringify(rd)
						return '<a style="cursor:pointer" class="hisui-linkbutton" onclick=objScreen.InSDManager('+index+')>'+$g("入组单病种")+'</a>';
						}
				}			
			
			},
			{field:'FPMDiag',title:'编目主诊断',width:'150',sortable:true,align:'left'}
			,
			{field:'ClinMDiag',title:'临床主诊断',width:'150',sortable:true,align:'left'}
		]]
	});
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


