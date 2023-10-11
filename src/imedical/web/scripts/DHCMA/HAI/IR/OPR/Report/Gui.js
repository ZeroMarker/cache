//手术切口调查表(报告)->Gui
var objScreen = new Object();
function InitINFOPSQryWin()
{
    var obj = objScreen;
    if (EmrOpen==1){
	    $('.page-footer').css('display','none');
    } 	
   	obj.RepStatus   = '';
	obj.ReportID    = ReportID;
	obj.OpsID       = OpsID;
	obj.OperAnaesID = OperAnaesID;
	obj.OperLocID   ='';
	obj.ReportDate  ='';
	obj.ReportTime  =''
	obj.RepLocID    ='';
	obj.RepUserID   ='';
	
	if (Common_RadioValue('radInfAnti')!=1) {
		$('#divINFAnti').attr("style","display:none");
	}else {
		$('#divINFAnti').removeAttr("style");
	}
	
	obj.LoadDataCss = function() {
		//初始化下拉菜单
		obj.cboOperType = Common_ComboDicID('cboOperType', 'HAIOperType');
		obj.cboIncision = Common_ComboDicID('cboIncisionE', 'CuteType');
		obj.cboHealing = Common_ComboDicID('cboHealing', 'CuteHealing');
		obj.cboAnesMethod = Common_ComboDicID('cboAnesMethod', 'Anesthesia');
		obj.cboASAScore = Common_ComboDicID('cboASAScore', 'ASAScore');
		obj.chkOperComp = Common_CheckboxToDic('chkOperComp', 'IRPostoperComps', 10);
		obj.cboNNISLevel = Common_ComboDicID('cboNNISLevel', 'NNISLevel');
		obj.cboVisitResult=Common_ComboDicID('cboVisitResult', 'VisitResult');
	}
	
    
    //手术部位
    obj.cboInfPos = $HUI.combobox("#cboInfPos", {
        url: $URL,
        editable: true,
        allowNull: true,
        defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
        valueField: 'ID',
        textField: 'Desc',
        onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
            param.ClassName = 'DHCHAI.BTS.InfPosSrv';
            param.QueryName = 'QryInfPosByCode';   //手术部位
    		    param.aPosCode='07';
     	    	/*
     			//感染诊断/部位
     			param.QueryName = 'QryInfPos';
       			param.aPosFlg = "s#2";
       		*/
       		  param.ResultSetType = 'array';
            param.ResultSetType = 'array';
        }
    });
    
    obj.gridOprInfoLoad = function() {
    	$HUI.datagrid("#gridOprInfo",{
			title:$g('手术信息')+'<span style="margin-left:30px;padding:6px 15px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;"><span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="color:#1278b8;font-weight: 700;">'+$g("提示信息")+'：'+$g('选中一条手术信息后填写手术切口调查，切换选中查看本次就诊其他手术调查登记情况')+'</span></span>',
			headerCls:'panel-header-gray',
			iconCls:'icon-paper',
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
			loadMsg:'数据加载中...',
			loading:true,
			columns:[[
				{field:'OperName',title:'手术名称',width:220},
				{field:'OperType',title:'手术类型',width:80},
				{field:'OperLoc',title:'手术科室',width:150},
				{field:'OperDate',title:'手术开始时间',width:150,
					formatter: function(value,row,index){
						return row.OperDate+" "+row.SttTime;	
					}
				},
				{field:'EndDate',title:'手术结束时间',width:150,
					formatter: function(value,row,index){
						return row.EndDate+" "+row.EndTime;	
					}
				},
				{field:'OperDocTxt',title:'手术医生',width:100},
				{field:'Anesthesia',title:'麻醉方式',width:100},
				{field:'CuteType',title:'切口类型',width:80},
				{field:'CuteHealing',title:'愈合情况',width:80},
				{field:'NNISLevel',title:'NNIS分级',width:80}
			]],
			onSelect:function(rindex,rowData){
				if (rindex>-1) {
					obj.OpsID = rowData.ID;
					obj.OperAnaesID = rowData.OperAnaesID;
					obj.OperLocID = rowData.OperLocID;
					obj.ReportInfo(obj.OpsID,obj.OperAnaesID);
				}
			},
			onLoadSuccess:function(data){
				dispalyEasyUILoad(); //隐藏效果 
				var total = data.total;
				if	(total>0) {	
	                if (obj.OpsID) {
						for (r=0;r<total;r++) {
							if (obj.OpsID==data.rows[r].ID) {
								$(this).datagrid('selectRow',r);
								continue;
							}
						}
					} else if (obj.OperAnaesID) {   //选中选择记录
						for (r=0;r<total;r++) {
							if (obj.OperAnaesID==data.rows[r].OperAnaesID) {
								$(this).datagrid('selectRow',r);
								continue;
							}
						}
					}else {  //默认选中第一条 临床填报
						$(this).datagrid('selectRow',0);
					}
				}
			}
		});
    }
    InitINFOPSQryWinEvent(obj);
    obj.LoadEvent();
	return obj;
}