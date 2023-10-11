//摘要[检验报告]-Gui
var objScreen = new Object();
function InitListReportWin(){
	var obj = new Object();
	obj.LabOeordDesc="";
	obj.CatType=""
	//定义背景色[异常标识颜色]
	obj.AbFlagBack = new Array();
	obj.AbFlagBack["H"]="#EEEE00"; 	//高
	obj.AbFlagBack["L"]="#EEEE00"; 	//低
	obj.AbFlagBack["PH"]="#FF3333"; //高危急值
	obj.AbFlagBack["PL"]="#FF3333"; //低危急值
	
	//初始化下拉菜单[分类]
	obj.reCboTestSet=function(){
		$HUI.combobox("#cboTestSet", {
            url: $URL,
            editable: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'ID',
            textField: 'TestSet',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.DPS.LabTestSetSrv';
                param.QueryName = 'QryLabTestSet';
                param.aActive = 1;
                param.aCatCode =obj.CatType;
                param.ResultSetType = 'array';
            },
            onChange: function (rec) {
	            //刷新标本表
	            obj.RefreshGridLabVisitNumber();
            }
        });
	}
	
	//加载表格-送检医嘱
	obj.gridLabVisitNumber = $HUI.datagrid("#gridLabVisitNumber",{
		fit: true,
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, 		//如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, 	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:false,
		//fitColumns: true,
		sortName:'CollDate',
		sortOrder:'desc',
		remoteSort:false,    //是否是服务器对数据排序
		url: $URL,
		queryParams:{
			ClassName:'DHCHAI.DPS.LabVisitRepSrv',
			QueryName:'QryLabVisitNumber',
			aEpisodeID:PaadmID,
			aDateFrom:"",
			aDateTo:"",
			aTestSetDr:$('#cboTestSet').combobox('getValue'),
			aCatCode:obj.CatType,
			aAlias:$('#SerchBox').searchbox('getValue')
	    },
		columns:[[
			{field:'EpisodeNo',title:'检验号',width:150},
			{field:'OrdTSDesc',title:'医嘱',width:250,
				formatter: function (value, row, index) {
                    return value + ' (' + row.Specimen + ' )' + "<a style='color:#00BFFF;font-weight:bold;'>"+((row.MRBDesc !='') ? (' (' + row.MRBDesc + ' )'):'')+"</a>";
                }
			},
			{field:'LocDesc',title:'送检科室',width:100},
			{field:'CollDate',title:'送检日期',width:160,sortable:true},
			{field:'AuthDate',title:'报告日期',width:160,sortable:true}
		]],
		onSelect: function (Index, rowData) { 
			//赋值
			obj.LabOeordDesc=rowData.OrdTSDesc;
			$('#txtLabOe').html(obj.LabOeordDesc);	
			obj.ReportID=rowData.VisitReportID;
			//刷新检验结果
			obj.RefreshGridLabVisitRepResult();
		}
		,rowStyler: function (index, row) {
			if (row.Anomalyflag != 0) {
				return 'color:red;';
			}
        }
        
	});
	//检验结果
	obj.gridLabVisitRepResult = $HUI.datagrid("#gridLabVisitRepResult",{
		fit: true,
		title: "检验结果",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:false,
		//fitColumns: true,
		columns:[[
			{field:'TestDesc',title:'检验项目',width:150},
			{field:'Result',title:'结果值',width:125,
				formatter: function (value, row, index) {
                    var val = value + ' ' + row.Unit //+ ((row.MDRResult.indexOf("1")!=-1) ? '（多耐菌）' : '')
					return '<span title="'+ val +'">' + val + '</span>';
                }
            },
			{field:'AbFlag',title:'异常提示',width:80,showTip:true,
				styler: function(value,row,index){
					if (typeof obj.AbFlagBack[row.AbFlag] != "undefined"){
				//	return '<div style="background:'+obj.AbFlagBack[row.AbFlag]+';width:100%;">'+row.AbFlag+'</div>';
					return 'background-color:'+obj.AbFlagBack[row.AbFlag]+';color:white;';
				} else {
					return row.AbFlag;
			}
		},
            },
			{field:'RefRanges',title:'参考范围',width:100,showTip:true}
		]],
		onLoadSuccess:function(data) {
			var Len = data.total;
			if (Len<1) return;
			var html = "";
			for (var i=0;i<Len;i++){
				var RstFormat = data.rows[i].RstFormat;
				var ResultID = data.rows[i].ResultID;
				var ResuntSen = $cm ({									//初始化年(最近十年)
					ClassName:"DHCHAI.DPS.LabVisitRepSrv",
					QueryName:"QryResultSen",
					aResultID:ResultID
				},false);
				var SenLen=ResuntSen.total;
				if (SenLen<1) continue;
				if (SenLen){
					html+="<tr style='line-height: 35px;'><td colspan='3' style='color:#40a2de;font-weight:bold;text-align:center;border-right-width:1px;border-top-width:1px;'>"+data.rows[i].Result+"</td></tr>";
					html+="<tr style='line-height: 30px;font-weight: normal;background: #eee '>";
					html+="<td style='border-top:0;padding-left:10px;width:80px;'>抗生素代码</td>";
					html+="<td style='border-top:0;padding-left:10px;width:200px;'>抗生素名称</td>";
					html+="<td style='border-top:0;padding-left:10px;border-right-width:1px;width:150px;'>结果</td>";
					html+="</tr>";
					
					for (var j=0;j<SenLen;j++){
						html+="<tr style='line-height: 30px;font-weight: normal;'>";
						html+="<td style='border-top:0;padding-left:10px;'>"+ResuntSen.rows[j].AntCode+"</td>";
						html+="<td style='border-top:0;padding-left:10px;'>"+ResuntSen.rows[j].AntDesc+"</td>";
						html+="<td style='border-top:0;padding-left:10px;border-right-width:1px;'>"+ResuntSen.rows[j].Sensitivity+ ((ResuntSen.rows[j].IsInt==1) ? '<div style="display:inline;margin-left:3px;background-color:red;color:#fff;border-radius:3px;font-size:10px;padding:2px;width:18px;font-weight: 600;">天</div>' :'')+"</td>";
						html+="</tr>";
					}
				}
				if (html!=""){
					html ="<tfoot><tr>"+"<th colspan='4'><table cellspacing='0' style='white-space: nowrap;font-size:12px;padding-top:30px;width:470px;'>"+html+"</table></th>"+"</tr></tfoot>";
					$("#gridLabVisitRepResult").prev().children(".datagrid-body").append(html);
				}
			}
			
			
		}
	});
	
	InitListReportWinEvent(obj);
	obj.LoadEvent();
	return obj;
}