// ����: ��������ķ�װ
// ����: ��������ķ�װ
// ��д�ߣ�XuChao
// ��д����: 2018.03.19

//����panelĬ��iconCls
//$.fn.panel.defaults.iconCls='icon-paper';
//����dialogĬ��iconCls
$.fn.dialog.defaults.iconCls='icon-w-paper';
//����tree
(function($){
	$.parser.plugins.push("stkscgcombotree");//ע����չ���
	$.fn.stkscgcombotree = function(options, param) {//������չ���
		//��optionsΪ�ַ���ʱ��˵��ִ�е��Ǹò���ķ�����
		if (typeof options == "string") {
			return $.fn.combotree.apply(this, arguments);
		}
		options = options || {};
		//���������һ��ҳ����ֶ��ʱ��this��һ�����ϣ�����Ҫͨ��each������
		return this.each(function(){
			var jq = $(this);
			//$.fn.combotree.parseOptions(this)�����ǻ�ȡҳ���е�data-options�е�����
			var opts = $.extend({
				setDefaults: true,		//�Ƿ�Ĭ����ʾ
				onLoadSuccess: function(){
					jq.combotree('options')['setDefaultFun']();
					jq.combotree('textbox').bind("blur",function(){
						if(isEmpty(jq.combotree('getText'))){
							jq.combotree('setValue','')
						}
					})
				},
				setDefaultFun: function(){
					jq.stkscgcombotree('clear');
					if(jq.stkscgcombotree('options')['setDefaults'] !== false){
						var StrParam = jq.stkscgcombotree('options')['StrParam'];
						var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.MulStkCatGroup', 'GetDefaScg', StrParam);
						var ScgId = DefaInfo.split('^')[0], ScgDesc = DefaInfo.split('^')[1];
						if(ScgId && ScgDesc){
							jq.stkscgcombotree('setValue', ScgId);
						}
					}
				}
			}, $.fn.combotree.parseOptions(this), options);
			var StrParam = "^^^^"+gHospId+"^"+StkGrpHospid;
			if ((StkGrpHospid!="")&&(gHospId!=StkGrpHospid)){
				StrParam = "^^^^^"+StkGrpHospid;
			}else{
				StrParam = gLocId+"^"+gUserId+"^^^"+gHospId+"^"+StkGrpHospid;
			}
			var Data = $.cm({
				ClassName:"web.DHCSTMHUI.Util.StkGrp",
				MethodName:"GetScgChildNode",
				NodeId:"AllSCG",
				StrParam: StrParam,
				Type:"M"
			},false);
			//�����ö���myopts�ŵ�$.fn.combotree���������ִ�С�
			var myopts = $.extend(true, {
				StrParam: StrParam,		//�˲�������Ĭ��ֵ��ȡֵ����
				data:Data,
				editable:true
			}, opts);
			$.fn.combotree.call(jq, myopts);
		});
	}
	//��չsetFilterByLoc����
	$.extend($.fn.combotree.methods, {
		setFilterByLoc: function (jq, LocId, xLocId,ScgSet){
			if(isEmpty(xLocId)){xLocId=''};
			if(isEmpty(ScgSet)){ScgSet=''};
			var StrParam = LocId+"^"+gUserId+"^"+xLocId+"^"+ScgSet+"^"+gHospId+"^"+StkGrpHospid;
			var Data = $.cm({
				ClassName:"web.DHCSTMHUI.Util.StkGrp",
				MethodName:"GetScgChildNode",
				NodeId:"AllSCG",
				StrParam:StrParam,
				Type:"M"
			},false);
			$(jq).combotree('options')['StrParam'] = StrParam;
			$(jq).combotree('loadData',Data);
			$(jq).combotree('options')['setDefaultFun']();
		}
	});
	//��չreload����
	$.extend($.fn.combotree.methods, {
		load: function (jq,StkGrpHospidm){
			var StrParam = "^^^^"+gHospId+"^"+StkGrpHospidm;
			if ((StkGrpHospidm!="")&&(StkGrpHospidm!=gHospId)){
				StrParam = "^^^^^"+StkGrpHospidm;
			}else{
				StrParam = gLocId+"^"+gUserId+"^^^"+gHospId+"^"+StkGrpHospidm;
			}
			var Data = $.cm({
				ClassName:"web.DHCSTMHUI.Util.StkGrp",
				MethodName:"GetScgChildNode",
				NodeId:"AllSCG",
				StrParam:StrParam,
				Type:"M"
			},false);
			$(jq).combotree('options')['StrParam'] = StrParam;
			$(jq).combotree('loadData',Data);
			$(jq).combotree('options')['setDefaultFun']();
		}
	});
	
	/*
	 * SimpleCombo
	 * js���趨��data: [{'RowId':***,'Description':***},...]
	 */
	$.parser.plugins.push('simplecombobox');
	$.fn.simplecombobox = function(options, param) {
		if (typeof options == 'string') {
			return $.fn.combobox.apply(this, arguments);
		}
		options = options || {};
		var DefaData = [{'RowId':'', 'Description':'ȫ��'}, {'RowId':'Y', 'Description':'��'}, {'RowId':'N', 'Description':'��'}];
		return this.each(function(){
			var jq = $(this);
			var opts = $.extend({}, $.fn.combobox.parseOptions(this), options);
			var Data = options.data || DefaData;
			var myopts = $.extend(true, {
				data: Data,
				valueField: 'RowId',
				textField: 'Description'
			}, opts);
			$.fn.combobox.call(jq, myopts);
		});
	};
	
	/*
	 * combobox���˷�ʽ, ������jQuery.hisui.js
	 * defaultFilter����˵��:
	 * 	1:��ƥ��,�����ִ�Сд(hisuiĬ��)
	 * 	2:����,�����ִ�Сд
	 * 	3:��ƥ��,��ƴ������ĸ��ƥ��
	 * 	4:����,��ƴ������ĸ����,�����ִ�Сд
	 */
	$.extend($.fn.combobox.defaults, {
		valueField: 'RowId',
		textField: 'Description',
		defaultFilter: 4
	});
	$.extend($.fn.lookup.defaults, {
		width: 'auto',
		panelWidth: 145,
		isCombo: true,
		url: $URL,
		mode: 'local',
		filter: function(q, row){
			var v = row[$(this).lookup('options')['textField']];
			return v.indexOf(q.toLowerCase()) > -1 || $.hisui.toChineseSpell(v).toLowerCase().indexOf(q.toLowerCase()) > -1;
		},
		idField: 'RowId',
		textField: 'Description',
		columnsLoader: function(){
			return [[{field:'Description',title:'',width:100}]]
		},
		fitColumns: true,
		pagination: false
	});

	//����updateRow getChanges ��ȡ����ֵ������
	$.extend($.fn.datagrid.methods, {
		updateRow: function(jq, param){
			return jq.each(function(){
				var target = this;
				var state = $.data(target, 'datagrid');
				var opts = state.options;
				var row = opts.finder.getRow(target, param.index);
				var updated = false;
				for(var field in param.row){
					if (row[field] != param.row[field]){
						updated = true;
						break;
					}
				}
				if (updated){
					if ($.inArray(row, state.insertedRows) == -1){
						if ($.inArray(row, state.updatedRows) == -1){
							state.updatedRows.push(row);
						}
					}
					$.extend(row, param.row);
					opts.view.updateRow.call(opts.view, this, param.index, param.row);
				}
			});
		}
	})
})(jQuery);

// ������غ�,�Զ����õ�һЩ��չ
/*
//2019-12-01 hisui.js�д�����ͬ�Ĵ���,����ע�͵�
$(function(){
	$('.hisui-combobox').next().children(':text').bind('paste', function(e){
		var ComboElement = $(this).parent().prev();
		var q = e.originalEvent.clipboardData.getData('text');
		ComboElement.combobox('showPanel').combobox('options').keyHandler.query.call(ComboElement[0], q, e);
	});
});
*/
