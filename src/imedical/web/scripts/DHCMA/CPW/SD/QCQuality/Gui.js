//页面Gui
var objScreen = new Object();
var obj = new Object();
function InitviewScreen(){
	$.parser.parse(); // 解析整个页面 	
	var HospID=session['DHCMA.HOSPID']
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
	$HUI.combobox('#QCDic',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntitySrv&QueryName=QryQCEntity&ResultSetType=Array',
			valueField:'BTID',
			textField:'BTDesc'	  
	    })
	$HUI.combobox('#cboDateType',{
    	valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:'auto',
		editable:false,
		data:[
			{id:'',text:'-统计时间类型-'},
			{id:'1',text:'按年季度'},
			{id:'2',text:'按出院日期'},
			{id:'3',text:'按就诊日期'}
		],
		onSelect:function(row){
			if ((row.id=='2')||(row.id=='3')){
					$('#sDateFrom').show();
					$('#sDateTo').show();
					$('#sQuarter').hide();
					$('#cboQuarter').combobox('setValue','');
					$('#sYear').hide();	
					$('#cboYear').combobox('setValue','');
			}else{
					$('#sYear').show();	
					$('#sDateFrom').hide();
					$('#DateFrom').datebox('setValue','');
					$('#sDateTo').hide();
					$('#DateTo').datebox('setValue','');
				}
			}
    })
    $m({
		ClassName:'DHCMA.CPW.SDS.Stat.StatService',
		MethodName:'GetDefaultYears'	    
	},function(Jsonstr){
		var Jsondata=eval(Jsonstr)
		$HUI.combobox('#cboYear',{
		    valueField:'id',
			textField:'text',
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			data:Jsondata,
			onSelect:function(row){
			    if (row.id==""){
				    $('#sQuarter').hide();
				    $('#Quarter').combobox('setValue','');
				}else{
					$('#sQuarter').show();
				}
		    }
    	});
	})
	$('#cboQuarter').combobox({
	    valueField:'id',
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'',text:'-季度-'},
			{id:'1',text:'第一季度'},{id:'2',text:'第二季度'},
			{id:'3',text:'第三季度'},{id:'4',text:'第四季度'}
		]
    });
    obj.gridType = $HUI.datagrid("#gridType",{
			nowrap:false,
			loadMsg:'数据加载中...',
			fit:true,
			singleSelect:true,
			onLoadSuccess: function (data) {
				//datagrid头部 table 的最后一个tr 的td们，即columns的集合
				var headerTds = $(".datagrid-header-inner table tr:last-child").children();
				//datagrid主体 table 的首个tr 的td们，即第一个数据行
				var bodyTds = $(".datagrid-body table tr:first-child").children();
				var totalWidth = 0; //合计宽度，用来为datagrid头部和主体设置宽度
				//循环设置宽度
				bodyTds.each(function (i, objScreen) {
				var headerTd = $(headerTds.get(i));
				var bodyTd = $(bodyTds.get(i));
				//$("div:first-child", headerTds.get(i)).css("text-align", "center");
				var headerTdWidth = headerTd.width(); //获取第i个头部td的宽度
				//这里加5个像素 是因为数据主体我们取的是第一行数据，不能确保第一行数据宽度最宽，预留5个像素。有兴趣的朋友可以先判断最大的td宽度都在进行设置
				var bodyTdWidth = bodyTd.width();
				var width = 0;
				//如果头部列名宽度比主体数据宽度宽，则它们的宽度都设为头部的宽度。反之亦然
				if (headerTdWidth > bodyTdWidth) {
				width = headerTdWidth;
				bodyTd.width(width);
				headerTd.width(width);
				totalWidth += width;
				} else {
				width = bodyTdWidth;
				headerTd.width(width);
				bodyTd.width(width);
				totalWidth += width;
				}
				});
				var bodyTable = $(".datagrid-body table:first-child");
				//循环完毕即能得到总得宽度设置到头部table和数据主体table中
				//bodyTable.width(totalWidth + 55);
				bodyTable.width($(".datagrid-header-inner table tr:last-child").width());
				///将所有的列都设置为可以排序
				var columns = $("#gridType").datagrid("options").columns[0];
				for (i = 0; i < columns.length; i++) {
				columns[i].sortable = true;
				};
			}
			
		})
		obj.gridTypePeo = $HUI.datagrid("#gridTypePeo",{
			loadMsg:'数据加载中...',
			nowrap:false,        
			height:490,
			singleSelect:true,
			onLoadSuccess: function (data) {
				//datagrid头部 table 的最后一个tr 的td们，即columns的集合
				var headerTds = $(".hisui-dialog .datagrid-header-inner table tr:last-child").children();
				//datagrid主体 table 的首个tr 的td们，即第一个数据行
				var bodyTds = $(".hisui-dialog .datagrid-body table tr:first-child").children();
				var totalWidth = 0; //合计宽度，用来为datagrid头部和主体设置宽度
				//循环设置宽度
				bodyTds.each(function (i, objScreen) {
				var headerTd = $(headerTds.get(i));
				var bodyTd = $(bodyTds.get(i));
				//$("div:first-child", headerTds.get(i)).css("text-align", "center");
				var headerTdWidth = headerTd.width(); //获取第i个头部td的宽度

				//这里加5个像素 是因为数据主体我们取的是第一行数据，不能确保第一行数据宽度最宽，预留5个像素。有兴趣的朋友可以先判断最大的td宽度都在进行设置
				var bodyTdWidth = bodyTd.width();
				var width = 0;
				//如果头部列名宽度比主体数据宽度宽，则它们的宽度都设为头部的宽度。反之亦然
				if (headerTdWidth > bodyTdWidth) {
				width = headerTdWidth;
				bodyTd.width(width);
				headerTd.width(width);
				totalWidth += width;
				} else {
				width = bodyTdWidth;
				headerTd.width(width);
				bodyTd.width(width);
				totalWidth += width;
				}
				});
				var bodyTable = $(".hisui-dialog .datagrid-body table:first-child");
				//循环完毕即能得到总得宽度设置到头部table和数据主体table中
				//bodyTable.width(totalWidth + 55);
				bodyTable.width($(".hisui-dialog .datagrid-header-inner table tr:last-child").width());
				///将所有的列都设置为可以排序
				var columns = $("#gridTypePeo").datagrid("options").columns[0];
				for (i = 0; i < columns.length; i++) {
				columns[i].sortable = true;
				};
			}
			
		})
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}

