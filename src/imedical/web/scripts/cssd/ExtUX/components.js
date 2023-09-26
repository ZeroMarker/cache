// ����: ��������ķ�װ
// ����: ��������ķ�װ
// ��д�ߣ�wfg
// ��д����:2019-4-3

//����panelĬ��iconCls
//$.fn.panel.defaults.iconCls='icon-paper';
//������tree
(function($){
	$.parser.plugins.push("packagecombotree");//ע����չ���
	$.fn.packagecombotree = function(options, param) {//������չ���
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
					//��ʱ��д��
				}
			}, $.fn.combotree.parseOptions(this), options);
			
			var StrParam = "^";
			var Data = $.cm({
				ClassName:"web.CSSDHUI.Common.Dicts",
				MethodName:"GetPackageCommboTree",
				gLoc:gLocId,
				StrParam: StrParam
			},false);
			//�����ö���myopts�ŵ�$.fn.combotree���������ִ�С�
			var myopts = $.extend(true, {
				StrParam: StrParam,		//�˲�������Ĭ��ֵ��ȡֵ����
				data: Data,
				editable:true
			}, opts);
			
			$.fn.combotree.call(jq, myopts);
		});
	}
	//��չsetFilter����  (������������ )
	$.extend($.fn.combotree.methods, {
		setFilterByLoc: function (jq, LocId, xLocId,ScgSet){
			if(isEmpty(xLocId)){xLocId=''};
			if(isEmpty(ScgSet)){ScgSet=''};
			var StrParam = LocId+"^"+gUserId+"^"+xLocId+"^"+ScgSet;
			var Data = $.cm({
				ClassName:"web.CSSDHUI.Common.Dicts",
				MethodName:"GetPackageCommboTree",
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
		defaultFilter: 4,
		//ResultSetType: 'array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	
	$.extend($.fn.lookup.defaults, {
		width: 'auto',
		panelWidth: 175,
		isCombo: true,
		url: $URL,
		mode: 'local',
		filter: function(q, row){
			var v = row[$(this).lookup('options')['textField']];
			return v.indexOf(q.toLowerCase()) > -1 || $.hisui.toChineseSpell(v).toLowerCase().indexOf(q.toLowerCase()) > -1;
		},
		idField: 'RowId',
		textField: 'Description',
		columns: [[
			{field:'Description',title:'',width:100}
		]],
		fitColumns: true,
		pagination: false
	});
})(jQuery);

//����updateRow getChanges ��ȡ����ֵ������
(function($){
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