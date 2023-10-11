var sixTimes=[2,6,10,14,18,22];
$(function() {
	var columns=[[{"title":"第5周/第1天","align":"center","halign":"center"},{"title":"上午","align":"center","halign":"center","colspan":3},{"title":"下午","align":"center","halign":"center","colspan":3}],[{"title":"时间\t","field":"vsItem","align":"center","width":200},{"title":"2点","field":"point2","align":"center","width":100},{"title":"6点","field":"point6","align":"center","width":100},{"title":"10点","field":"point10","align":"center","width":100},{"title":"14点","field":"point14","align":"center","width":100},{"title":"18点","field":"point18","align":"center","width":100},{"title":"22点","field":"point22","align":"center","width":100}]];
	var data=[{"code":"temperature","times":[2,6,10,14,18,22],"vsItem":"腋温（℃）","options":[],"symbol":["外出","拒测"],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.3,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"rectemperature","times":[2,6,10,14,18,22],"vsItem":"肛温（℃）","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.2,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"oraltemperature","times":[2,6,10,14,18,22],"vsItem":"口温（℃）","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.2,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"pulse","times":[2,6,10,14,18,22],"vsItem":"脉搏（次/分）","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":60,"normalValueRangTo":100,"errorValueHightFrom":150,"errorValueLowTo":40,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"breath","times":[2,6,10,14,18,22],"vsItem":"呼吸（次/分）","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":12,"normalValueRangTo":24,"errorValueHightFrom":45,"errorValueLowTo":5,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"sysPressure","times":[6,14],"vsItem":"收缩压(mmHg)","options":[],"blank":false,"select":false,"validate":true,"colspan":3,"normalValueRangFrom":90,"normalValueRangTo":140,"errorValueHightFrom":160,"errorValueLowTo":60,"point2":"","point14":""},{"code":"diaPressure","times":[6,14],"vsItem":"舒张压(mmHg)","options":[],"blank":false,"select":false,"validate":true,"colspan":3,"normalValueRangFrom":60,"normalValueRangTo":90,"point2":"","point14":""},{"code":"degrBlood","times":[2,6,10,14,18,22],"vsItem":"血氧饱和度","options":[],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"heartbeat","times":[2,6,10,14,18,22],"vsItem":"心率（次/分）","options":[],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"phyCooling","times":[2,6,10,14,18,22],"vsItem":"物理降温(℃)","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.3,"errorValueHightFrom":43,"errorValueLowTo":35,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"painInten","times":[2,6,10,14,18,22],"vsItem":"疼痛评分","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":0,"normalValueRangTo":10,"errorValueHightFrom":11,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"defFreq","times":[14],"vsItem":"大便次数（次）","options":["0次","1次","2次","3次","3次以上"],"blank":false,"select":true,"validate":false,"colspan":6,"point2":""},{"code":"height","times":[14],"vsItem":"身高（cm）","options":[],"symbol":["外出","拒测"],"blank":false,"select":false,"validate":true,"colspan":6,"normalValueRangFrom":60,"normalValueRangTo":195,"point2":""},{"code":"weight","times":[14],"vsItem":"体重（KG）","options":[],"symbol":["外出","拒测"],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"liquidln","times":[14],"vsItem":"总入量（ml）","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"uriVolume","times":[14],"vsItem":"尿量（ml）","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"liquidOut","times":[14],"vsItem":"总出量（ml）","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"Barthel","times":[14],"vsItem":"Barthel评分","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"Item34","times":[2,6,10,14,18,22],"vsItem":"空白栏1标题","options":["引流量(ml)","心包引流(ml)","纵膈引流(ml)","心包纵膈引流(ml)","胸腔引流(ml)","胸腔引流左(ml)","胸腔引流右(ml)","腰大池引流(ml)","T管引流(ml)","腹腔引流(ml)","伤口引流(ml)","胃肠减压(ml)","脑室引流(ml)","腹膜后引流(ml)","耻骨后引流(ml)","肾造瘘左(ml)","肾造瘘右(ml)","膀胱造瘘(ml)","回肠造瘘(ml)","回肠引流(ml)","左侧输尿管引流(ml)","右侧输尿管引流(ml)","盆腔引流(ml)","大便量(ml)","呕吐量(ml)","汗液(ml)","腹水(ml)","胸水(ml)","月经量(ml)","超虑量(ml)","腹膜透析超滤量(ml)","阴道出血量(ml)","头部引流(ml)","腰穿压力(mmH2O)","CVP(mmHg)","肘静脉压(cmH2O)","有创动脉血压(mmHg)","腹围(cm)","左上肢血压(mmHg)","左下肢血压(mmHg)","右上肢血压(mmHg)","右下肢血压(mmHg)","CRRT(ml)","腿围左（上/下 cm）"],"blank":true,"select":false,"validate":false,"colspan":1,"blankTitleCode":"Item34_Title","blankTitleInputTime":23,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"Reason","times":[2,6,10,14,18,22],"vsItem":"未测原因","options":[],"symbol":["拒测","外出","请假"],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""}];
	$('#singleVSTable').datagrid({
		title:$g('体征采集'),
		// height:'600',
		// style:'width:98%;background:red;',
		singleSelect:true,
		toolbar: '#toolbar',
		headerCls:'panel-header-gray',
		iconCls:'icon-target-arrow',
		autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		columns:columns,
		data:data,
		onClickCell:function(index, field, value) {
			console.log(index, field, value);
			var rows=$('#singleVSTable').datagrid('getRows')
			if ("vsItem"==field) {
				if (!rows[index].blank) return;
				var bgColor=$('tr[datagrid-row-index="'+index+'"]>td[field="vsItem"]').css('backgroundColor');
				if ('rgb(228, 228, 228)'==bgColor) return;
			}
			colIndex=sixTimes.indexOf(parseInt(field.slice(5)));
			editTableCell(index, field);
		},
		onDblClickCell:function(index, field, value) {
			var rows=$('#singleVSTable').datagrid('getRows')
			if ("vsItem"==field) {
				if (!rows[index].blank) return;
				var $blankTitle=$('tr[datagrid-row-index="'+index+'"]>td[field="vsItem"]');
				var bgColor=$blankTitle.css('backgroundColor');
				if ('rgb(228, 228, 228)'==bgColor) {
					$blankTitle.css('backgroundColor','transparent');
					$.messager.popover({msg: $g('如若更改该空白栏标题，则本住院周的数据都将被更改。'),type:'info'});
				}
			}
		},
		onAfterEdit:function(index,data,changes){
			var rows=$('#singleVSTable').datagrid('getRows')
			margeTableCell(rows);
		},
		onLoadSuccess:function(data){
			margeTableCell(data.rows);
			updateSvsTableSize();
		}
	});
	var fixRowNum=4;
	var data={"columns":[{"field":"1||1||3","width":130},{"field":"1||1||2","width":130},{"field":"1||1||1","width":130}],"date2Id":{"2022-02-13":"1||1||3","2022-02-14":"1||1||2","2022-02-15":"1||1||1"},"doc":{},"finished":1,"rows":[{"1||1||1":"2022-02-15","1||1||2":"2022-02-14","1||1||3":"2022-02-13","adrsDesc":"评价日期"},{"1||1||1":"1","1||1||2":"2","1||1||3":"3","adrsDesc":"化疗周期数"},{"1||1||1":"护士01/护士01","1||1||2":"护士01","1||1||3":"护士01","adrsDesc":"评估/更新人"},{"adrsDesc":"审核人"},{"1||1||1":"2级","1||1||2":"3级","1||1||3":"3级","adrsDesc":"贫血","ardsId":"18||1","grades":{"1级":"血红蛋白< 正常值下限～ 10.0 g/dL；< 正常值下限～6.2 mmol/L；< 正常值下限～100 g/L","2级":"血红蛋白< 10.0～8.0 g/dL；< 6.2 ～4.9 mmol/L；< 100～80 g/L","3级":"血红蛋白< 8.0 g/dL；< 4.9 mmol/L；< 80 g/L；需要输血 治疗","4级":"危及生命；需要紧急治疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"3级","1||1||3":"3级","adrsDesc":"嗜酸性细胞增多","ardsId":"18||4","grades":{"1级":"> 正常值上限和> 基线","3级":"使用类固醇"}},{"1||1||1":"3级","1||1||2":"4级","1||1||3":"4级","adrsDesc":"发热性中性粒细胞减少","ardsId":"18||5","grades":{"3级":"ANC <1000/mm3 伴单次体温 >38.3℃（101℉）或持续体温 ≥38℃（100.4℉）超过1 小时。","4级":"危及生命；需要紧急治疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"2级","1||1||3":"2级","adrsDesc":"淋巴结痛","ardsId":"18||9","grades":{"1级":"轻度疼痛","2级":"中度疼痛；影响工具性日常 生活活动","3级":"重度疼痛；影响自理性日常 生活活动"}},{"1||1||1":"2级","1||1||2":"2级","1||1||3":"2级","adrsDesc":"高铁血红蛋白症","ardsId":"18||10","grades":{"2级":"> 正常值上限（ULN）","3级":"需要紧急治疗","4级":"危及生命","5级":"死亡"}},{"1||1||1":"3级","1||1||2":"3级","1||1||3":"3级","adrsDesc":"血栓性血小板减少性紫癜","ardsId":"18||11","grades":{"3级":"实验室检查异常并伴有临床 症状（例如：肾功能不全，瘀 斑）","4级":"危及生命；（例如：中枢神经 系统出血或血栓形成/栓塞或 肾功能衰竭）","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"血液和淋巴系统疾病–其他","ardsId":"18||12","grades":{"1级":"无症状或轻微；仅为临床或 诊断所见；无需治疗","2级":"中度；需要较小、局部或非侵 入性治疗；与年龄相当的工 具性日常生活活动受限","3级":"严重或者具重要医学意义但 不会立即危及生命；导致住 院或者延长住院时间；自理 性日常生活活动受限","4级":"危及生命；需要紧急治疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"主动脉瓣疾病","ardsId":"19||1","grades":{"1级":"无症状的瓣膜增厚，伴或不 伴有轻度瓣膜返流或狭窄 （影像学观察）","2级":"无症状；中度的瓣膜返流或 狭窄（影像学观察）","3级":"有症状；影像学显示重度瓣 膜返流或狭窄；症状可通过 治疗可以控制","4级":"危及生命；需要紧急治疗（例 如：瓣膜置换，瓣膜成形术）","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"心脏停搏","ardsId":"19||2","grades":{"1级":"周期性心脏停搏；无需紧急 医疗处理","4级":"危及生命；需要紧急治疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"房颤","ardsId":"19||3","grades":{"1级":"无症状，不需治疗","2级":"非紧急的医疗处理","3级":"有症状，需要紧急治疗；需要 仪器（例如：起搏器）或者消 融控制；新发","4级":"危及生命；血栓需要紧急治 疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"心房扑动","ardsId":"19||4","grades":{"1级":"无症状，不需治疗","2级":"非紧急的医疗处理","3级":"有症状，需要紧急治疗；需要 仪器（例如：起搏器）；消融 控制","4级":"危及生命；血栓需要紧急治 疗","5级":"死亡"}},{"1||1||1":"2级","1||1||2":"2级","1||1||3":"2级","adrsDesc":"完全性房室传导阻滞","ardsId":"19||5","grades":{"2级":"非紧急的医疗处理","3级":"有症状，药物不能完全控制 或需要仪器（例如：起搏器） 控制；新发症状","4级":"危及生命；需要紧急治疗","5级":"死亡"}},{"1||1||1":"1级","1||1||2":"1级","1||1||3":"1级","adrsDesc":"I 度房室传导阻滞","ardsId":"19||6","grades":{"1级":"无症状，不需治疗","2级":"非紧急的医疗处理","5级":"死亡"}}]};
	$('#subRecordTable').datagrid({
		showHeader:false,
			frozenColumns: [
					[{
							field: 'adrsDesc',
							width: 200,
							formatter: function(value, row, index) {
									if (index > (fixRowNum - 1)) {
											var str = '<a href="javascript:void(0);" name="showADRsCurve" data-id="' + row.ardsId + '" class="easyui-linkbutton" ></a>';
											return value + str;
									} else {
											return value;
									}
							}
					}]
			],
			columns: [data.columns],
			data: { total: data.rows.length, rows: data.rows },
			onLoadSuccess: function(data) {
					$("a[name='checkSubRecord']").map(function(index, elem) {
							var id = $(this).data('id');
							var status = $(this).data('status');
							$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-eye' });
					});
					$("a[name='auditSubRecord']").map(function(index, elem) {
							var id = $(this).data('id');
							$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-paper-stamp' });
					});
					$("a[name='recallSubRecord']").map(function(index, elem) {
							var id = $(this).data('id');
							$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-cancel-order' });
					});
					$("a[name='editSubRecord']").map(function(index, elem) {
							var id = $(this).data('id');
							if (docFlag) {
									var status = $(this).data('status');
									$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-edit' });
							} else {
									$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-edit' });
							}
					});
					$("a[name='delSubRecord']").map(function(index, elem) {
							var id = $(elem).data('id');
							$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-remove' });
					});
					$("a[name='showADRsCurve']").map(function(index, elem) {
							var id = $(elem).data('id');
							$(elem).linkbutton({ plain: true, size: 'small', iconCls: 'icon-analysis' });
					});
			}
	});
	$('#subRecordTable').datagrid('freezeRow', 0).datagrid('freezeRow', 1).datagrid('freezeRow', 2).datagrid('freezeRow', 3);
	$('#subRecordTable').datagrid('resize', {
			height: window.innerHeight - 200
	})

	$('#dg6').datagrid({
		title:'地区',
		height:'200',
		width:window.innerWidth-40,
		columns:[
			[
				{title:'行序号',align:'left',halign:'center',rowspan:3,field:'no'}	
				,{title:'地区',align:'left',halign:'center',colspan:6}
			],[
				{title:'北京', align:'left',halign:'center',colspan:3},
				{title:'上海', align:'left',halign:'center',colspan:3}
			],[
				{title:'朝阳区',field:'bjzy', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'海淀区',field:'bjhd', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'昌平区',field:'bjzp', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'虹口区',field:'bjhk', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'徐汇区',field:'bjxf', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'宝山区',field:'bjbs', align:'left',halign:'center',sortable:true,order:'asc',width:82}
			]
		],
		data:[{
			"no":false,
			"bjzy":true,
			"bjhd":1,
			"bjzp":36.3,
			"bjhk":37.3,
			"bjxf":43,
			"bjbs":34,
			}],
		onLoadSuccess:function(data){
			updateSvsTableSize();
		}
	});
});
function margeTableCell(rows){
	rows.map(function(e,i) {
		if (e.times.length<6) {
			e.times.map(function(e1,i1) {
				$('#singleVSTable').datagrid('mergeCells',{
					index: i,
					field: 'point'+sixTimes[i1*e.colspan],
					colspan: e.colspan
				});
			})
		}
	})
}
function updateSvsTableSize() {
	var n=0;
	var timer = setInterval(function(){
		var innerHeight=window.innerHeight;
		var innerWidth=window.innerWidth;
		if ($('#singleVSTable').datagrid) {
			$('#singleVSTable').datagrid('resize',{
				width:innerWidth-40,
			  height:innerHeight-8
			})
			$('#dg6').datagrid('resize',{
				width:innerWidth-40,
			  height:innerHeight-338
			})
		}
		n++;
		if(n>6) {
			clearInterval(timer);
		}
	},200);
}
window.addEventListener("resize",updateSvsTableSize);
