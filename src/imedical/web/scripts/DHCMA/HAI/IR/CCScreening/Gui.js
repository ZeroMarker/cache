//页面Gui
function InitCCScreeningWin(){
	var obj = new Object();
	LocGroupDr = ServerObj.LocGroupDr;
	LocGroupFlg = ServerObj.LocGroupFlg;
	obj.tatal = '';
	
	if (LocFlag==1) {  //科室权限
		$('#divLayout').empty();
		$('#divLayout').css('display','none');
		
	}else {
		$('#divAccordion').empty();
		$('#divAccordion').css('display','none');
		
        var HsopID = $.LOGON.HOSPID;
		var UserID = $.LOGON.USERID;
		var User = $.LOGON.USERDESC;
		obj.cboHospital = Common_ComboToSSHosp("cboHospital",HsopID);
		
		//医院表格联动
		$HUI.combobox('#cboHospital',{
			onSelect:function(data){
				$('#cboGroup').combobox('clear');
				obj.LoadGroup(data.ID);
				//加载感染科室疑似筛查汇总  
				obj.gridLocInf();
				obj.gridLocInfLoad();
			}
		});
		obj.LoadGroup =  function(HsopID) {
			$HUI.combobox("#cboGroup", {
				url: $URL,
				editable: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'GroupUser',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.IRS.CCLocGroupSrv';
					param.QueryName = 'QryLocGroupUser';
					param.aHospIDs  = HsopID;
					param.aViewFlag = "W";
					param.aGrpType  = LocGroupDr;
					param.ResultSetType = 'array';
				},
				onSelect:function(data){
					if (LocGroupFlg==1) {
						//加载感染科室疑似筛查汇总
						obj.gridLocInfLoad();
					}						
				},
				onChange:function(newValue,oldValue){   //清空当前工作组，显示全部信息
					if ((LocGroupFlg==1)&&(newValue=="")) { 
						//加载感染科室疑似筛查汇总
						obj.gridLocInfLoad();
					}						
				},
				onLoadSuccess:function(data){   //初始加载赋值
					if (data.length>1){
						$(this).combobox('enable');
						for (var i=0;i<data.length;i++) {
							if (User == data[i]['GroupUser']) {
								$(this).combobox('select',data[i]['ID']);
							}
						}
					}else {
						$(this).combobox('select',data[0]['ID']);
					}
				}
			});
		}
	}
	
	//临床科室患者明细
   	obj.gridAdmInfo = function() {
		$HUI.datagrid("#gridAdmInfo",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			loadMsg:'数据加载中...',
			columns:[[
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:72}, 
				{field:'CurrBed',title:'床号',width:53,align:'center'},
				{field:'IsMessage',title:'消息',width:42,align:'center',
					formatter: function(value,row,index){
						if (value==1) {
							return "<a style='position: relative;'><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
									+((row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>未</span>":'')
									+"</a>";		
						}else {
							return '';
						}
					}	
				},	
				{field:'IsNeedAtt',title:'需关注',width:58,align:'center',
					formatter: function(value,row,index){
						if (value==1){
							return "<a class='icon-star-yellow'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
						}else{
							return '';
						}	
					}
				},
				{field:'NeedRepCnt',title:'需上报',width:58,align:'center'}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				//if ((field=='IsMessage')&&(value==1)) return;
				if (rindex>-1) {
					var rData = $('#gridAdmInfo').datagrid('getRows')[rindex];
					obj.gridAdmInfo_onSelect(rindex,'',rData);
				}	
			}
		});
	}
	
	//责任患者列表
	obj.gridDutyList = function() {
		$HUI.datagrid("#gridDutyList",{
			fit: true,
			pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏,默认显示50条数据
			rownumbers: true, //如果为true, 则显示一个行号列
			singleSelect: true,
			loadMsg:'数据加载中...',
			columns:[[
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'姓名',width:72}, 
				{field:'CurrBed',title:'床号',width:53,align:'center'},
				{field:'IsMessage',title:'消息',width:42,align:'center',
					formatter: function(value,row,index){
						if (value==1) {
							return "<a style='position: relative;' ><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + index + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"
									+((row.LocUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>未</span>":'')
									+"</a>";							
						}else {
							return '';
						}
					}	
				},	
				{field:'IsNeedAtt',title:'需关注',width:58,align:'center',
					styler: function(value,row,index){
						if (row.IsNeedAtt==1){
							//return 'background-color:#00FFFF;';
							return "<a href='#' class='icon-star-yellow' data-options='plain:true,'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"
							
						}else{
							return '';
						}
					}
				},
				{field:'NeedRepCnt',title:'需上报',width:58,align:'center'}
			]]
			,rowStyler: function(index,row){
				if (row.IsSusInf==1) { //疑似
					if (row.SuspendCode==0){   //0待处理  1已处理
						return 'color:red'; 
					}
					if (row.SuspendCode==1){   
						return 'color:black'; 
					}
				}else {
					return 'color:gray'; 
				}
			},onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
				if (rindex>-1) {
					var rData = $('#gridDutyList').datagrid('getRows')[rindex];
					obj.gridAdmInfo_onSelect(rindex,'',rData);
				}	
			}
		});
	}

	//感染科室疑似筛查汇总
	obj.gridLocInf = function() {
		$HUI.datagrid("#gridLocInf",{   
			fit:true,
			nowrap:false,
			fitColumns:true,
			singleSelect:true,
			pagination:false,
			remoteSort:false,   //本地数据排序必须设置为false
			sortName:'LocDesc',
			sortOrder:'desc',
			loadMsg:'数据加载中...',
			columns:[[ 
				{field:'LocDesc',title:'科室名称',width:170}, 
				{field:'InPatientCnt',title:'在科<br>人数',width:50,align:'center'},
				{field:'ScreenProCnt',title:'疑似<br>待处理',width:65,align:'center'},
				{field:'ScreenLogCnt',title:'未报/确诊',width:85,align:'center',
					formatter: function(value,row,index){
						return row.DiagNoRepCnt+" / "+row.ConfirmCnt;
					}
				},
				{field:'ScreenAttCnt',title:'需关注',width:65,align:'center'}
			]],
			view: detailview,
			detailFormatter:function(index, rowData){	
				if ((rowData.ScreeningCnt==0)&&($("#chkIsInf").checkbox('getValue'))) {
					//无数据
					return '<div style="padding:8px;text-align:center;background-color:#E3F7FF;color:#1474AF;"><span class="icon-tip" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>无疑似患者</div>'
				}else {	
					//科室患者明细
					return '<div style="padding:5px 5px 5px 0px;"><table id=gridAdmInfo'+index+'></table></div>';
				}
			}, 
			onExpandRow: function(pindex, rowData){
				if (pindex>=obj.tatal) {  //合计行不展开数据
					$('#gridLocInf').datagrid('collapseRow',pindex);
					//$("#gridLocInf").datagrid('clearSelections');  //取消选中
				}
				var rows = $('#gridLocInf').datagrid('getRows');
				$.each(rows,function(i,k){
					//获取当前所有展开的子网格
					var expander = $('#gridLocInf').datagrid('getExpander',i);
					if(expander.length && expander.hasClass('datagrid-row-collapse')){
						if(k.LocID != rowData.LocID){
							//折叠上一次展开的子网格
							$('#gridLocInf').datagrid('collapseRow',i);
						}
					}
				});
				
				obj.gridLocAdmInfo = $HUI.datagrid('#gridAdmInfo'+pindex,{   //科室患者明细
				    idField:'EpisodeID',
					pageSize: 10,
					pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
					showPageList:false,  //不显示页面尺寸的选择列表		
					singleSelect: true,
					autoRowHeight: true,
					//sortName:'SuspendCode',
					//sortOrder:'asc',
					loadMsg:'数据加载中...',
					url:$URL,
					queryParams:{
						ClassName:'DHCHAI.IRS.CCScreeningSrv',
						QueryName:'QrySuRulePatList',
						aTypeFlag:(Common_RadioValue('radAdmStatus') ? Common_RadioValue('radAdmStatus'):'1'),
						aDateFrom:$('#aDateFrom').datebox('getValue'), 
						aDateTo:$('#aDateTo').datebox('getValue'), 
						aLocID:rowData.LocID,
						aIsInf:($("#chkIsInf").checkbox('getValue') ? 1: ''), 
						aPatInfo:$('#aPatName').val()+"^"+$('#aRegNo').val()+"^"+$('#aMrNo').val()+"^"+$('#aBed').val()
					},
					columns:[[
						{field:'SuspendCode',title:'状态',hidden:true}, 
						{field:'RegNo',title:'登记号',width:100},	 
						{field:'PatName',title:'姓名',width:85}, 
						{field:'CurrBed',title:'床号',width:65,align:'center',
							styler: function(value,row,index){
								if (row.NeedRepCnt>0) {
									return 'background-color:#CCFFFF';	
								}
							}	
						},
						{field:'IsMessage',title:'消息',width:55,align:'center',
							formatter: function(value,row,rindex){
								if (value==1) {
									return "<a style='position: relative;' ><img class='green-message' onclick='btnMessage_click(this,\"" + row.EpisodeID + "\",\"" + pindex +  "\",\"" + rindex + "\")' src='../scripts/DHCMA/HAI/img/消息-选中.png'>"	
									+((row.AdminUnRead==1)? "<span style='position: absolute;color:red;bottom:10px;font-size:8px;'>未</span>":'')
									+"</a>";	
								}else {
									return '';
								}
							}	
						},	
						{field:'IsNeedAtt',title:'需关注',width:65,align:'center',
							formatter: function(value,row,index){
								if (value==1){
									return "<a class='icon-star-yellow'>&nbsp;&nbsp;&nbsp;&nbsp;</a>"		
								}else{
									return '';
								}	
							}
						}
					]]
					,rowStyler: function(index,row){
						if (row.IsSusInf==1) {  //疑似
							//if ((row.SuspendCode==0)&&(!$("#chkIsInf").checkbox('getValue'))){   //0待处理  1已处理
							if (row.SuspendCode=='0') {
								return 'color:red'; 
							}
							if (row.SuspendCode=='1'){   
								return 'color:balck'; 
							}
						}else {
							return 'color:gray'; 
						}
					},
					onResize: function () {
						$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
					},
					onClickCell: function(rindex,field,value){  //刷新设置选中后执行两遍，换成onClickCell
						if (rindex>-1) {
							var rData = $('#gridAdmInfo'+pindex).datagrid('getRows')[rindex];
							obj.gridAdmInfo_onSelect(pindex,rindex,rData);
						}	
					},
					onLoadSuccess: function (data) {
						setTimeout(function () {
							$('#gridLocInf').datagrid('fixDetailRowHeight', pindex);
						}, 0);
					}				
				});
			}
			,onClickCell: function(rindex,field,value){  //展开时onSelect 执行两遍，换成onClickCell
			    if (rindex>=obj.tatal) return;  //合计行不允许操作
				if ( field=="_expander") return;
				if (rindex>-1) {
					var rowData = $('#gridLocInf').datagrid('getRows')[rindex];
					obj.gridLocInf_onSelect(rindex,'',rowData);
				}	
			},onLoadSuccess:function(data) {
				obj.tatal = data.total;   //获取原始数据行总数
				if (data.total>1) {					
					$('#gridLocInf').datagrid('appendRow',{
						LocDesc:'<span class="subtotal">全院合计</span>',
						InPatientCnt:'<span class="subtotal">'+compute("InPatientCnt")+'</span>',
						ScreenProCnt:'<span class="subtotal">'+compute("ScreenProCnt")+'</span>',
						DiagNoRepCnt:'<span class="subtotal">'+compute("DiagNoRepCnt")+'</span>',
						ConfirmCnt:'<span class="subtotal">'+compute("ConfirmCnt")+'</span>',
						ScreenAttCnt:'<span class="subtotal">'+compute("ScreenAttCnt")+'</span>'
					});
				}
			}
		});
	}
	
	//指定列求和
	function compute(colName) {
		var rows = $('#gridLocInf').datagrid('getRows');
		
		var total = 0;
		for (var i = 0;i<rows.length;i++) {
			total +=parseFloat(rows[i][colName]);
		}
		return total;
	}
	InitPatDtl(obj);
	InitCCScreeningWinEvent(obj);	
	obj.LoadEvent(arguments);
	
	return obj;
}


