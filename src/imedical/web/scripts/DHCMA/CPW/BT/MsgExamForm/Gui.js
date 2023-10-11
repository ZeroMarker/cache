//页面Gui
var obj = new Object();
function InitViewFromWin(){	
    var viewColumns = [];			//类标题数组
    
    //当前审核角色
   var retRole = $m({
		ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
		MethodName:"GetRoleName",
		aRecDtlID:RecDtlID
	},false);
	obj.RoleName=retRole.split("^")[0];			//审核角色
	obj.ExamResult=retRole.split("^")[1];		//审核结果
	obj.ExamOpinion=retRole.split("^")[2];		//审核意见
	$("#txtOpinion").val(obj.ExamOpinion);
	
	
    
    //当前表单路径
    $cm({
		ClassName:"DHCMA.CPW.BT.PathForm",
		MethodName:"GetObjById",
		aId:PathFormID
	},function(data){
		obj.CurrPathID=data.FormPathDr;
	});
    
    //表单主页面
    $cm({
		ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
		QueryName:"QryPathFormEp",
		aPathFormDr:PathFormID,
		ResultSetType:"array",
	},function(rs){
		//动态添加列标题
		for (var i=0;i<rs.length;i++){
			var tmpObj = rs[i];
			viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc,styler:function(v,r,i){return 'position:relative;'}}
		}		
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			MethodName:"GetViewFormItems",
			aPathFormID:PathFormID
		},function(rs){
			$("#textDays").text(rs.days);
			$("#textCost").text(rs.cost);
			
			//获取表单视图
			obj.gridViewForm = $HUI.datagrid("#gridViewForm",{
				fit: true,
				title:'路径名称：<span style=\"color:#1584D2\"><b>'+rs.name+'<b/></span><a id=\"imgEditPath\" title=\"查看路径信息\" class=\"hisui-linkbutton\" onclick=obj.showPathInfoDiag() data-options=\"iconCls:\'icon-write-order\',plain:true\"></a><span style="float:right;font-weight:normal">审核角色：'+obj.RoleName+'</span>',
				headerCls:'panel-header-white', //配置项使表格变成灰色
				pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
				rownumbers: false, //如果为true, 则显示一个行号列
				singleSelect: false,
				autoRowHeight: true, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
				loadMsg:'数据加载中...',
				pageSize: 99,
				pageList : [20,50,100,200],
				data:rs,
			    frozenColumns: [[
		        	{ field: 'step', title: '步骤', width: 100,align:'right',styler: function (value, row, index) {
             			return 'background-color:#F4F6F5;';
          			}},
		        ]],
				columns:[viewColumns],
				onBeforeLoad: function (param) {
		            var firstLoad = $(this).attr("firstLoad");
		            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
		            {
		                $(this).attr("firstLoad","true");
		                return false;
		            }
		            return true;
				},
				onLoadSuccess:function(){
					$(this).prev().find('div.datagrid-body').unbind('mouseover');
					$("input:not(:text)").attr("disabled", "disabled");  
					
					if (obj.ExamResult!="-1"){			// 已审核表单需等待表单数据加载成功后设置按钮不可用
						$("#btnPass").linkbutton("disable")
						$("#btnNoPass").linkbutton("disable")
					}
					$.parser.parse();
				},
				onClickRow: function (rowIndex, rowData) {
    				$(this).datagrid('unselectRow', rowIndex);
				}
				,
				rowStyler: function(index,row){
					return 'background-color:#F7FBFF;';
				},
				loadFilter:function(data){
					//console.log(data)
					for(var key in data.rows[2]){
						if(key=="step") continue; 
						data.rows[2][key]="<img id='img-"+key.split('-')[1]+"'  class='imgLnkOrds' title='查看关联医嘱' onclick=obj.ViewLnkOrds(this.id) style='cursor:pointer;padding:10px;position:absolute;top:5px;right:5px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png'></img></br>"+data.rows[2][key];
					}
					return data;		
				}
			});
		})
	})
	
	//阶段医嘱明细
	obj.gridOrders = $HUI.datagrid("#gridOrders",{
		fit: true,
		//height:400,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return;
			if(value==undefined) return;
				return value + ' , 共( ' + rows.length + ' )项';
			},
		scrollbarSize: 0,
		checkOnSelect: true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 50,
		pageList : [50,100,150,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:"",
			aPathFormEpItemDr:"",
			aHospID:"",
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:9999
	    },
		columns:[[
			{field:'checkOrd',checkbox:true,hidden:true,align:'center',width:'',auto:false},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'300'
				,formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return value+chkPosDesc+"<label id= 'pop"+FJid+"' style='color:red;' onmouseover=obj.ShowFJDetail("+FJid+") onmouseout=obj.DestoryFJDetail("+FJid+")>[详细]</label>"
					}else if(row['OrdMastID'].split("||").length!=2){
						var ARCOSRowid=row['OrdMastID'];
						var ARCOSDesc=row['OrdMastIDDesc'];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label style='color:red;cursor:pointer;' onclick=ShowARCOSDetail('"+ARCOSRowid+"')>[明细]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=obj.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span>"
					}
				}
			},
			{field:'OrdLnkOrdDr',title:'关联号',width:'50'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'主医嘱',width:'70'},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'}
		]]
	})
	
	//医嘱明细弹窗初始化
	$('#winViewLnkOrds').dialog({
		title: '关联医嘱明细',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		width:'1200',
		height:'500'
	});
	
	//医嘱套医嘱列表
  	obj.gridARCOSOrder = $HUI.datagrid("#gridARCOSOrder",{
		fit: true,
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: false,
		remoteSort:false,
		sortName:"SeqNo",
		sortOrder:"asc",
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',   
		columns:[[
			{field:'ARCIMDesc',title:'医嘱名称',width:'300'},
			{field:'DoseQty',title:'单次剂量',width:'80'},
			{field:'DoseUOMDesc',title:'剂量单位',width:'80'},
			{field:'FreqDesc',title:'频次',width:'80'},
			{field:'InstrDesc',title:'用法',width:'80'},
			{field:'DurDesc',title:'疗程',width:'80'},
			{field:'SeqNo',title:'序号',width:'80'}	
		]],
		onBeforeLoad: function (param) {
	        var firstLoad = $(this).attr("firstLoad");
	        if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	        {
	            $(this).attr("firstLoad","true");
	            return false;
	        }
	        return true;
		},
		rowStyler: function(index,row){
			var SeqNo=row.SeqNo;
			if (SeqNo=="") return;
			if (SeqNo.indexOf(".")>-1) return 'background-color:#cdf1cd;';
			else return 'background-color:#94e494;';						
		}
	});
	
	ShowARCOSDetail = function(ARCOSRowid){
		$('#gridARCOSOrder').datagrid('loadData',{rows:[],total:0});
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryOrderByARCOS",
			ARCOSRowid:ARCOSRowid,
			aHospID:session['DHCMA.HOSPID'],
			page:1,
			rows:99999
		},function(rs){
			$('#gridARCOSOrder').datagrid('loadData',rs);
			$('#ARCOSCPWDialog').dialog({title:"当前医嘱明细"});   
			$HUI.dialog('#ARCOSCPWDialog').open();
		})	
	}
	
	InitViewFormWinEvent(obj);
	obj.LoadEvents(arguments);
	$.parser.parse();
}