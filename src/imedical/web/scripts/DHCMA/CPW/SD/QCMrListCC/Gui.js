//页面Gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	UpAdmin=false; //默认不可上传
    $.parser.parse(); // 解析整个页面 	
    var HospID=session['DHCMA.HOSPID']
    $HUI.combobox('#Status',
	    {
			url:$URL+'?ClassName=DHCMA.Util.BTS.DictionarySrv&QueryName=QryDictByType&ResultSetType=Array&aTypeCode=SDQCMrStatus',
			valueField:'BTCode',
			textField:'BTDesc',	
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false
	    })
	$HUI.combobox('#Hospital',
	    {
			url:$URL+'?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=Array&aHospID='+HospID,
			valueField:'OID',
			textField:'Desc',
	    	onSelect:function(rd){
		    	HospID=rd.OID;
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I';
        		$('#LocDic').combobox('setValue','');
        		$('#LocDic').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('Hospital',HospID);
			   	$('#search').click();
			   }		    
	    } )	
	$HUI.combobox('#LocDic',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I',
			valueField:'OID',
			textField:'Desc',
			onSelect:function(rd){
		    	LocID=rd.OID;
		    	var url=$URL+'?ClassName=DHCMA.Util.EPS.CareProvSrv&QueryName=QryCareProvInfo&ResultSetType=Array&aLocID='+LocID;
        		$('#DocDic').combobox('setValue','');
        		$('#DocDic').combobox('reload', url);
		   },		    
	    })
	$HUI.combobox('#DocDic',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.Util.EPS.CareProvSrv&QueryName=QryCareProvInfo&ResultSetType=Array',
			valueField:'OID',
			textField:'Desc'	  
	    })
	$HUI.combobox('#QCDic',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntitySrv&QueryName=QryQCEntity&ResultSetType=Array',
			valueField:'BTID',
			textField:'BTDesc'	  
	    })
	 $HUI.combobox('#DateType',
	    {
		    data:[
		    	{'DateType':'InEntiy','Desc':"入组日期"},
		    	{'DateType':'OutHosp','Desc':"出院日期"}
		    ],
			valueField:'DateType',
			textField:'Desc',
	    }) 
	Common_SetValue('DateType','OutHosp');
    $HUI.linkbutton('#search',{
	    iconCls:'icon-w-find'
	    }) 
	$HUI.linkbutton('#updoAll',{
	    iconCls:'icon-w-msg'
	    }) 
	var LocAdmin=$m({
		ClassName:'DHCMA.Util.BT.Config',
		MethodName:'GetValueByCode',
		aCode:'SDLocManager'
		
	},false)
	if ((tDHCMedMenuOper['admin'])||(tDHCMedMenuOper['HosAdmin']))
	 {
		 //院级权限
		 UpAdmin=true;
	}else if(LocAdmin.indexOf(session['LOGON.USERNAME'])>-1) {
		Common_SetValue('LocDic',session['DHCMA.CTLOCID']);
		$("#LocDic").combobox('disable'); 
		$("#Hospital").combobox('disable'); 
		//院级权限
		 UpAdmin=true;
	}else {
		Common_SetValue('LocDic',session['DHCMA.CTLOCID']);
		Common_SetValue('DocDic',session['DHCMA.CarePID']);
		$("#LocDic").combobox('disable'); 
		$("#Hospital").combobox('disable'); 
		$("#DocDic").combobox('disable'); 
		//var frm  = dhcsys_getmenuform();
	 }
	obj.gridQCMrList = $HUI.datagrid("#gridQCMrList",{
		fit:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		displayMsg: "当前表格显示 {from} 到 {to} ,共 {total} 条记录",
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		striped:true,
		rownumbers:true, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,50],
		idField:"RowID",
		sortName:"DisDate",
		sortOrder:"asc",
	    url:$URL,
	    bodyCls:'no-border',
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.QCMrListSrv",
			QueryName:"QryQCMrListCC"
	    },
		columns:[[
			{field:'QCEntityDesc',title:'病种名称',width:'200',align:'left',sortable:true},
			{field:'UpLoad',title:'是否上报',width:'80',align:'left',sortable:true,
				formatter: function(value,row,index){
						if (value==1) {
							return "<span style='color:green'>已上报</span>";
						}else{
							return "未上报"	
						}
				}	
			},
			{field:'UpLastDays',title:'迟报天数',width:'100',align:'left',sortable:true,
				styler: function(value,row,index){
						if ((value>=5)&&(value<7)) {
							return "background-color:yellow"
						}else if((value>=7)&&(value<9)){
							return "background-color:orange";
						}else if(value>=9){
							return "background-color:red";
						}
				}},
			{field:'MrNo',title:'病案号',width:'100',align:'left'},
			{field:'PatName',title:'患者姓名',width:'100',align:'left',sortable:false},
			{field:'DocName',title:'管床医生',width:'100',align:'left',sortable:false},
			{field:'AdmDate',title:'入院日期',width:'120',align:'left',sortable:true},
			{field:'DisDate',title:'出院日期',width:'120',align:'left',sortable:true},
			{field:'RowID',title:'住院病历',width:'120',align:'left',sortable:true,
				formatter: function(value,row,index){
						var paadm=row.EpisodeID.split('!!')[0]
						var patientID=row.PatID
						return " <a href='#' class='hisui-linkbutton hover-dark' style='cursor:pointer' onclick='objScreen.DisplayEPRView(\"" + paadm + "\",\"" + patientID + "\");'>病历浏览</a>";
				}			
			
			}
		]],
		groupField:'GroupInfo',
		view:groupview,
		groupFormatter:function(value, rows){
			return '<span style="font-size:14px;color:#00BFFF">'+value+'</span>' ;
	        }
		,onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridQCMrList_onDbselect(rowData);
			}
		}
		,onLoadSuccess:function(rowIndex,rowData){
			HISUIHtml.call()
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


