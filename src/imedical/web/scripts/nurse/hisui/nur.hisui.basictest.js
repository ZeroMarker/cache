var sixTimes=[2,6,10,14,18,22];
$(function() {
	var columns=[[{"title":"��5��/��1��","align":"center","halign":"center"},{"title":"����","align":"center","halign":"center","colspan":3},{"title":"����","align":"center","halign":"center","colspan":3}],[{"title":"ʱ��\t","field":"vsItem","align":"center","width":200},{"title":"2��","field":"point2","align":"center","width":100},{"title":"6��","field":"point6","align":"center","width":100},{"title":"10��","field":"point10","align":"center","width":100},{"title":"14��","field":"point14","align":"center","width":100},{"title":"18��","field":"point18","align":"center","width":100},{"title":"22��","field":"point22","align":"center","width":100}]];
	var data=[{"code":"temperature","times":[2,6,10,14,18,22],"vsItem":"Ҹ�£��棩","options":[],"symbol":["���","�ܲ�"],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.3,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"rectemperature","times":[2,6,10,14,18,22],"vsItem":"���£��棩","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.2,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"oraltemperature","times":[2,6,10,14,18,22],"vsItem":"���£��棩","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.2,"errorValueHightFrom":43,"errorValueLowTo":34,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"pulse","times":[2,6,10,14,18,22],"vsItem":"��������/�֣�","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":60,"normalValueRangTo":100,"errorValueHightFrom":150,"errorValueLowTo":40,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"breath","times":[2,6,10,14,18,22],"vsItem":"��������/�֣�","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":12,"normalValueRangTo":24,"errorValueHightFrom":45,"errorValueLowTo":5,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"sysPressure","times":[6,14],"vsItem":"����ѹ(mmHg)","options":[],"blank":false,"select":false,"validate":true,"colspan":3,"normalValueRangFrom":90,"normalValueRangTo":140,"errorValueHightFrom":160,"errorValueLowTo":60,"point2":"","point14":""},{"code":"diaPressure","times":[6,14],"vsItem":"����ѹ(mmHg)","options":[],"blank":false,"select":false,"validate":true,"colspan":3,"normalValueRangFrom":60,"normalValueRangTo":90,"point2":"","point14":""},{"code":"degrBlood","times":[2,6,10,14,18,22],"vsItem":"Ѫ�����Ͷ�","options":[],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"heartbeat","times":[2,6,10,14,18,22],"vsItem":"���ʣ���/�֣�","options":[],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"phyCooling","times":[2,6,10,14,18,22],"vsItem":"������(��)","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":36.3,"normalValueRangTo":37.3,"errorValueHightFrom":43,"errorValueLowTo":35,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"painInten","times":[2,6,10,14,18,22],"vsItem":"��ʹ����","options":[],"blank":false,"select":false,"validate":true,"colspan":1,"normalValueRangFrom":0,"normalValueRangTo":10,"errorValueHightFrom":11,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"defFreq","times":[14],"vsItem":"���������Σ�","options":["0��","1��","2��","3��","3������"],"blank":false,"select":true,"validate":false,"colspan":6,"point2":""},{"code":"height","times":[14],"vsItem":"��ߣ�cm��","options":[],"symbol":["���","�ܲ�"],"blank":false,"select":false,"validate":true,"colspan":6,"normalValueRangFrom":60,"normalValueRangTo":195,"point2":""},{"code":"weight","times":[14],"vsItem":"���أ�KG��","options":[],"symbol":["���","�ܲ�"],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"liquidln","times":[14],"vsItem":"��������ml��","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"uriVolume","times":[14],"vsItem":"������ml��","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"liquidOut","times":[14],"vsItem":"�ܳ�����ml��","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"Barthel","times":[14],"vsItem":"Barthel����","options":[],"blank":false,"select":false,"validate":false,"colspan":6,"point2":""},{"code":"Item34","times":[2,6,10,14,18,22],"vsItem":"�հ���1����","options":["������(ml)","�İ�����(ml)","��������(ml)","�İ���������(ml)","��ǻ����(ml)","��ǻ������(ml)","��ǻ������(ml)","���������(ml)","T������(ml)","��ǻ����(ml)","�˿�����(ml)","θ����ѹ(ml)","��������(ml)","��Ĥ������(ml)","�ܹǺ�����(ml)","��������(ml)","��������(ml)","��������(ml)","�س�����(ml)","�س�����(ml)","������������(ml)","�Ҳ����������(ml)","��ǻ����(ml)","�����(ml)","Ż����(ml)","��Һ(ml)","��ˮ(ml)","��ˮ(ml)","�¾���(ml)","������(ml)","��Ĥ͸��������(ml)","������Ѫ��(ml)","ͷ������(ml)","����ѹ��(mmH2O)","CVP(mmHg)","�⾲��ѹ(cmH2O)","�д�����Ѫѹ(mmHg)","��Χ(cm)","����֫Ѫѹ(mmHg)","����֫Ѫѹ(mmHg)","����֫Ѫѹ(mmHg)","����֫Ѫѹ(mmHg)","CRRT(ml)","��Χ����/�� cm��"],"blank":true,"select":false,"validate":false,"colspan":1,"blankTitleCode":"Item34_Title","blankTitleInputTime":23,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""},{"code":"Reason","times":[2,6,10,14,18,22],"vsItem":"δ��ԭ��","options":[],"symbol":["�ܲ�","���","���"],"blank":false,"select":false,"validate":false,"colspan":1,"point2":"","point6":"","point10":"","point14":"","point18":"","point22":""}];
	$('#singleVSTable').datagrid({
		title:$g('�����ɼ�'),
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
					$.messager.popover({msg: $g('�������ĸÿհ������⣬��סԺ�ܵ����ݶ��������ġ�'),type:'info'});
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
	var data={"columns":[{"field":"1||1||3","width":130},{"field":"1||1||2","width":130},{"field":"1||1||1","width":130}],"date2Id":{"2022-02-13":"1||1||3","2022-02-14":"1||1||2","2022-02-15":"1||1||1"},"doc":{},"finished":1,"rows":[{"1||1||1":"2022-02-15","1||1||2":"2022-02-14","1||1||3":"2022-02-13","adrsDesc":"��������"},{"1||1||1":"1","1||1||2":"2","1||1||3":"3","adrsDesc":"����������"},{"1||1||1":"��ʿ01/��ʿ01","1||1||2":"��ʿ01","1||1||3":"��ʿ01","adrsDesc":"����/������"},{"adrsDesc":"�����"},{"1||1||1":"2��","1||1||2":"3��","1||1||3":"3��","adrsDesc":"ƶѪ","ardsId":"18||1","grades":{"1��":"Ѫ�쵰��< ����ֵ���ޡ� 10.0 g/dL��< ����ֵ���ޡ�6.2 mmol/L��< ����ֵ���ޡ�100 g/L","2��":"Ѫ�쵰��< 10.0��8.0 g/dL��< 6.2 ��4.9 mmol/L��< 100��80 g/L","3��":"Ѫ�쵰��< 8.0 g/dL��< 4.9 mmol/L��< 80 g/L����Ҫ��Ѫ ����","4��":"Σ����������Ҫ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"3��","1||1||3":"3��","adrsDesc":"������ϸ������","ardsId":"18||4","grades":{"1��":"> ����ֵ���޺�> ����","3��":"ʹ����̴�"}},{"1||1||1":"3��","1||1||2":"4��","1||1||3":"4��","adrsDesc":"������������ϸ������","ardsId":"18||5","grades":{"3��":"ANC <1000/mm3 �鵥������ >38.3�棨101�H����������� ��38�棨100.4�H������1 Сʱ��","4��":"Σ����������Ҫ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"2��","1||1||3":"2��","adrsDesc":"�ܰͽ�ʹ","ardsId":"18||9","grades":{"1��":"�����ʹ","2��":"�ж���ʹ��Ӱ�칤�����ճ� ����","3��":"�ض���ʹ��Ӱ���������ճ� ����"}},{"1||1||1":"2��","1||1||2":"2��","1||1||3":"2��","adrsDesc":"����Ѫ�쵰��֢","ardsId":"18||10","grades":{"2��":"> ����ֵ���ޣ�ULN��","3��":"��Ҫ��������","4��":"Σ������","5��":"����"}},{"1||1||1":"3��","1||1||2":"3��","1||1||3":"3��","adrsDesc":"Ѫ˨��ѪС����������","ardsId":"18||11","grades":{"3��":"ʵ���Ҽ���쳣�������ٴ� ֢״�����磺�����ܲ�ȫ���� �ߣ�","4��":"Σ�������������磺������ ϵͳ��Ѫ��Ѫ˨�γ�/˨���� ������˥�ߣ�","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"ѪҺ���ܰ�ϵͳ�����C����","ardsId":"18||12","grades":{"1��":"��֢״����΢����Ϊ�ٴ��� �����������������","2��":"�жȣ���Ҫ��С���ֲ������ �������ƣ��������൱�Ĺ� �����ճ���������","3��":"���ػ��߾���Ҫҽѧ���嵫 ��������Σ������������ס Ժ�����ӳ�סԺʱ�䣻���� ���ճ���������","4��":"Σ����������Ҫ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"�������꼲��","ardsId":"19||1","grades":{"1��":"��֢״�İ�Ĥ���񣬰�� ������Ȱ�Ĥ��������խ ��Ӱ��ѧ�۲죩","2��":"��֢״���жȵİ�Ĥ������ ��խ��Ӱ��ѧ�۲죩","3��":"��֢״��Ӱ��ѧ��ʾ�ضȰ� Ĥ��������խ��֢״��ͨ�� ���ƿ��Կ���","4��":"Σ����������Ҫ�������ƣ��� �磺��Ĥ�û�����Ĥ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"����ͣ��","ardsId":"19||2","grades":{"1��":"����������ͣ����������� ҽ�ƴ���","4��":"Σ����������Ҫ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"����","ardsId":"19||3","grades":{"1��":"��֢״����������","2��":"�ǽ�����ҽ�ƴ���","3��":"��֢״����Ҫ�������ƣ���Ҫ ���������磺������������ �ڿ��ƣ��·�","4��":"Σ��������Ѫ˨��Ҫ������ ��","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"�ķ��˶�","ardsId":"19||4","grades":{"1��":"��֢״����������","2��":"�ǽ�����ҽ�ƴ���","3��":"��֢״����Ҫ�������ƣ���Ҫ ���������磺������������ ����","4��":"Σ��������Ѫ˨��Ҫ������ ��","5��":"����"}},{"1||1||1":"2��","1||1||2":"2��","1||1||3":"2��","adrsDesc":"��ȫ�Է��Ҵ�������","ardsId":"19||5","grades":{"2��":"�ǽ�����ҽ�ƴ���","3��":"��֢״��ҩ�ﲻ����ȫ���� ����Ҫ���������磺������ ���ƣ��·�֢״","4��":"Σ����������Ҫ��������","5��":"����"}},{"1||1||1":"1��","1||1||2":"1��","1||1||3":"1��","adrsDesc":"I �ȷ��Ҵ�������","ardsId":"19||6","grades":{"1��":"��֢״����������","2��":"�ǽ�����ҽ�ƴ���","5��":"����"}}]};
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
		title:'����',
		height:'200',
		width:window.innerWidth-40,
		columns:[
			[
				{title:'�����',align:'left',halign:'center',rowspan:3,field:'no'}	
				,{title:'����',align:'left',halign:'center',colspan:6}
			],[
				{title:'����', align:'left',halign:'center',colspan:3},
				{title:'�Ϻ�', align:'left',halign:'center',colspan:3}
			],[
				{title:'������',field:'bjzy', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'������',field:'bjhd', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'��ƽ��',field:'bjzp', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'�����',field:'bjhk', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'�����',field:'bjxf', align:'left',halign:'center',sortable:true,order:'asc',width:82},
				{title:'��ɽ��',field:'bjbs', align:'left',halign:'center',sortable:true,order:'asc',width:82}
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
