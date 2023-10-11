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
			blurValidValue:true,
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
		    	var url =$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I&aType=E';
        		$('#LocDic').combobox('setValue','');
        		$('#LocDic').combobox('reload', url);
		   },
		   onLoadSuccess:function(){
			   	Common_SetValue('Hospital',HospID);
			   }		    
	    } )	
	$HUI.combobox('#LocDic',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=Array&aHospID='+HospID+'&aAdmType=I&aType=E',
			valueField:'OID',
			textField:'Desc',
			blurValidValue:true,
			onSelect:function(rd){
		    	LocID=rd.OID;
		    	var url=$URL+'?ClassName=DHCMA.Util.EPS.CareProvSrv&QueryName=QryCareProvInfo&ResultSetType=Array&aLocID='+LocID+"&aTypeCode=D";
        		$('#DocDic').combobox('setValue','');
        		$('#DocDic').combobox('reload', url);
		   }		    
	    })
	$HUI.combobox('#DocDic',
	    {
		    defaultFilter:4,
		    blurValidValue:true,
			url:$URL+'?ClassName=DHCMA.Util.EPS.CareProvSrv&QueryName=QryCareProvInfo&ResultSetType=Array',
			valueField:'OID',
			textField:'Desc'	  
	    })
	$HUI.combobox('#QCDic',
	    {
		    defaultFilter:4,
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
		    blurValidValue:true,
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntitySrv&QueryName=QryQCEntity&ResultSetType=Array',
			valueField:'BTID',
			textField:'BTDesc'	  
	    })
	 $HUI.combobox('#DateType',
	    {
		    data:[
		    	{'DateType':'InEntiy','Desc':$g("入组日期")},
		    	{'DateType':'OutHosp','Desc':$g("出院日期")}
		    ],
			valueField:'DateType',
			textField:'Desc'
	    }) 
	Common_SetValue('DateType','OutHosp');
    $HUI.linkbutton('#search',{
	    iconCls:'icon-w-find'
	}) 
	$HUI.linkbutton('#updoAll',{
	    iconCls:'icon-w-msg'
	}) 

	if ((tDHCMedMenuOper['admin'])||(tDHCMedMenuOper['HosAdmin']))
	 {
		 UpAdmin=true;
	}else {
		Common_SetValue('LocDic',session['DHCMA.CTLOCID']);
		Common_SetValue('DocDic',session['DHCMA.CarePID']);
		$("#LocDic").combobox('disable'); 
		$("#Hospital").combobox('disable'); 
		if (session['DHCMA.CarePID'])	//能取到用户信息，限定登录用户
		{
			$("#DocDic").combobox('disable');
		}
		$('#updoAll').hide();			//非管理员权限，不显示批量上报按钮
	 }
	obj.gridQCMrList = $HUI.datagrid("#gridQCMrList",{
		fit:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: false,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false,
		striped:true,
		rownumbers:true, 
		pageSize: 10,
		pageList : [10,50],
		idField:"RowID",
		columns:[[
			{field:'checked',checkbox:'true',align:'left',width:30,auto:false},
			{field:'QCEntityDesc',title:'管理病种',width:'200',align:'left',sortable:true},
			{field:'QCInDateT',title:'入单日期',width:'200',align:'left',sortable:true},
			{field:'LocDesc',title:'管理科室',width:'150',align:'left',sortable:true},
			{field:'QCCurrStatus',title:'当前状态',width:'80',align:'left',sortable:true,
				formatter: function(value,row,index){
						var ExcludeInfo=row.ExcludeInfo
						var reg = new RegExp( ',' , "g" )
						ExcludeInfo=ExcludeInfo.replace(reg,"<br>")
						if (value=="O") {
							return '<a title="'+ExcludeInfo+'" class="hisui-tooltip grid-tips" onclick=objScreen.StatusToggle("'+value+"\","+row.RowID+","+row.QCEntityID+')><span style="color:red;">'+$g(row.QCCurrStatusDesc)+'</span></a>';
							
						}else if (value=="I") {
							return '<a title="'+ExcludeInfo+'" class="hisui-tooltip grid-tips" onclick=objScreen.StatusToggle("'+value+"\","+row.RowID+","+row.QCEntityID+')><span style="color:green;">'+$g(row.QCCurrStatusDesc)+'</span></a>';
						}else{
							if (ExcludeInfo=="") {
									return $g(row.QCCurrStatusDesc);
							}else{
								 	return '<a title="'+ExcludeInfo+'" class="hisui-tooltip grid-tips" >'+$g(row.QCCurrStatusDesc)+'</a>';
							}
						}
				}
			},
			{field:'MrNo',title:'病案号',width:'120',align:'left'},
			{field:'PatName',title:'患者姓名',width:'150',align:'left',sortable:false},
			{field:'DocName',title:'管理医生',width:'150',align:'left',sortable:false},
			{field:'AdmDate',title:'入院日期',width:'120',align:'left',sortable:true},
			{field:'DisDate',title:'出院日期',width:'120',align:'left',sortable:true},
			{field:'RowID',title:'住院病历',width:'150',align:'left',sortable:true,
				formatter: function(value,row,index){
						var paadm=row.EpisodeID.split('!!')[0]
						var patientID=row.PatID
						return " <a href='#' class='hisui-linkbutton hover-dark' style='cursor:pointer' onclick='objScreen.DisplayEPRView(\"" + paadm + "\",\"" + patientID + "\");'>"+$g('病历浏览')+"</a>";
				}			
			
			},{field:'EpisodeID',title:'上传<br>接口平台',width:'100',align:'left',id:'UpForm',sortable:true,hidden:UpAdmin?false:true,
				formatter: function(value,row,index){
						if (row.QCCurrStatus=="Up") {
							return '<span style="color:green;">'+$g('已上传')+'</span>';
						}else if (row.QCCurrStatus=="Check" || row.QCCurrStatus=="tUp") {
							return '<a href="#" class="hisui-linkbutton" onclick=objScreen.UpForm('+row.RowID+","+"\"\""+')>'+$g('上传')+'</a>';
						}else{
							//return '<a href="#" class="hisui-linkbutton" onclick=objScreen.UpForm('+row.RowID+","+"\"\""+')>上传</a>';
							return '<a class="hisui-linkbutton" style="color:black;">'+$g('待审核')+'</a>';
						}
						
				}			
			
			}
		]]
		,onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){			
				obj.gridQCMrList_onDbselect(rowData);
			}
		}
		,onLoadSuccess:function(rowData){
			$('#gridQCMrList').datagrid('loaded');
		}
	});
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


