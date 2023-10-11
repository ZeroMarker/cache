//页面Gui
function InitHISUIWin(){
	var obj = new Object();
	$.parser.parse(); // 解析整个页面 
	obj.ArcFlag=1
	obj.ArcItemFlag=3
	
	$HUI.combobox("#cboSSHosp", {
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'OID',
		textField: 'Desc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMA.Util.EPS.HospitalSrv';
			param.QueryName = 'QryHospInfo';
			param.aHospID=session['DHCMA.HOSPID'];
			param.aIsActive="1";
			param.ResultSetType = 'array';
		},onSelect:function(rows){
		    obj.GridArcLoad();
	    },onUnselect:function(rows){
		    obj.GridArcLoad();
	    },
		onAllSelectClick:function(e){
			obj.GridArcLoad();
		}
	});
	
	obj.cboHospInLoc = Common_ComboToSSHosp2("cboHospInLoc",session['DHCMA.HOSPID'],"");
	obj.cboHospInType = Common_ComboToSSHosp2("cboHospInType",session['DHCMA.HOSPID'],"");
	obj.cboHospInPath = Common_ComboToSSHosp2("cboHospInPath",session['DHCMA.HOSPID'],"");
	
	//科室
	$HUI.combobox('#cboHospInLoc',{
	    onSelect:function(rows){
		    var LocHospID=rows["OID"];
		    $HUI.combobox("#cboLoc", {
				url:$URL,
				onBeforeLoad:function(param){
					param.ClassName="DHCMA.Util.EPS.LocationSrv",
					param.QueryName="QryLocInfo",
					param.aHospID=LocHospID,
					param.aType="E",
					param.aAdmType="I",
					param.ResultSetType='array'	
				},
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				valueField: 'OID',
				textField: 'Desc',
				defaultFilter:4,
				onSelect:function(rows){
				    obj.GridArcLoad();
			    },
			    onUnselect:function(rows){
				    obj.GridArcLoad();
			    },
				onAllSelectClick:function(e){
					obj.GridArcLoad();
				}
			}); 
	    }
    });
    
    //路径类型
    $HUI.combobox('#cboHospInType',{
	    onSelect:function(rows){
		    var TypeHospID=rows["OID"];
		    $HUI.combobox("#cboType",{
				url:$URL,
				onBeforeLoad:function(param){
					param.ClassName="DHCMA.CPW.BTS.PathTypeSrv",
					param.QueryName="QryPathType",
					param.aHospID=TypeHospID,
					param.ResultSetType='array'	
				},
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				valueField: 'BTID',
				textField: 'BTDesc',
				defaultFilter:4,
				onSelect:function(rows){
				    obj.GridArcLoad();
			    },
			    onUnselect:function(rows){
				    obj.GridArcLoad();
			    },
				onAllSelectClick:function(e){
					obj.GridArcLoad();
				}
			});
			
	    }
    });
    
    //路径
    $HUI.combobox('#cboHospInPath',{
	    onSelect:function(rows){
		    var PathHospID=rows["OID"];
		    $HUI.combobox("#cboPath",{
				url:$URL,
				onBeforeLoad:function(param){
					param.ClassName="DHCMA.CPW.BTS.PathLocSrv",
					param.QueryName="QryPathMast",
					param.aAdmType="I",
					param.aHospID=PathHospID,
					param.ResultSetType='array'	
				},
				multiple:true,
				rowStyle:'checkbox', //显示成勾选行形式
				editable: true,
				valueField: 'BTID',
				textField: 'BTDesc',
				defaultFilter:4,
				onSelect:function(rows){
				    obj.GridArcLoad();
			    },
			    onUnselect:function(rows){
				    obj.GridArcLoad();
			    },
				onAllSelectClick:function(e){
					obj.GridArcLoad();
				}
			});
	    }
    });


    	
	//医院维护的医嘱
	obj.GridArc = $HUI.datagrid("#GridArc",{
		border:false,
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'BTDesc',title:'已维护医嘱信息',width:'350',align:'center'},
			{field:'BTLevelType',title:'维度',width:'200',align:'center'},
			{field:'BTType',title:'医嘱类型',width:'80',align:'center'}
		]]
	});

	
	//医嘱
	obj.GridArcItem = $HUI.datagrid("#GridArcItem",{
		border:false,
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'BTDesc',title:'医嘱信息',width:'450',align:'center'}
		]]
	});

	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
