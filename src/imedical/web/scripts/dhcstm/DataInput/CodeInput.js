// 数据字典导入
var CodeGrid = new Ext.grid.GridPanel({
		id: 'CodeGrid',
		stripeRows: true,
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					deleteDetail(CodeGrid);
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					clearData(CodeGrid);
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					saveDetail();
				}
			}
		],
		store: new Ext.data.SimpleStore({
        fields: [
           {name:'catgrp'},
           {name:'stkcat'},
           {name:'code'},
           {name:'desc'},
           {name:'spec'},

           {name:'brand'},
           {name:'abbr'},
           {name:'alias'},
           {name:'buom'},
           {name:'puom'},

           {name:'factor',type: 'int'},
           {name:'sp',type: 'float'},
           {name:'rp',type: 'float'},
           {name:'charge'},
           {name:'highvalue'},

           {name:'batrequired'},
           {name:'expdaterequired'},
           {name:'vendor'},
           {name:'manf'},
           {name:'registerno'},

           {name:'registerexpdate'},
           {name:'businesslicense'},
           {name:'businesscertificate'},
           {name:'businesscertificateexpdate'},
           {name:'productionlicense'},

           {name:'productionlicenseexpdate'},
           {name:'authorizationdate'},
           {name:'contactperson'},
           {name:'contacttel'},
           {name:'remarks'}

			]
		}),
		columns: [
            new Ext.grid.RowNumberer(),
            {header: '库存大类名称', width: 120,dataIndex: 'catgrp'},
            {header: '库存子类名称', width: 150, dataIndex: 'stkcat'},
            {header: '物资代码', width: 80, dataIndex: 'code'},
            {header: '名称', width: 120,dataIndex: 'desc'},
            {header: '规格型号', width: 150, dataIndex: 'spec'},

            {header: '品牌', width: 80, dataIndex: 'brand'},
            {header: '简称', width: 120,dataIndex: 'abbr'},
            {header: '别名', width: 150, dataIndex: 'alias'},
            {header: '最小单位', width: 80, dataIndex: 'buom'},
            {header: '整包装单位', width: 120,dataIndex: 'puom'},

            {header: '整包转换系数', width: 80, dataIndex: 'factor'},
            {header: '售价', width: 80, dataIndex: 'sp'},
            {header: '进价', width: 80, dataIndex: 'rp'},
            {header: '是否收费', width: 120,dataIndex: 'charge'},
            {header: '是否高值', width: 150, dataIndex: 'highvalue'},

            {header: '是否需要批号', width: 80, dataIndex: 'batrequired'},
            {header: '是否需要效期', width: 120,dataIndex: 'expdaterequired'},
            {header: '供应商名称', width: 150, dataIndex: 'vendor'},
            {header: '生产厂商名称', width: 80, dataIndex: 'manf'},
            {header: '器械注册证号', width: 80, dataIndex: 'registerno'},

            {header: '器械注册证效期', width: 120,dataIndex: 'registerexpdate'},
            {header: '营业执照号', width: 150, dataIndex: 'businesslicense'},
            {header: '经营许可证号', width: 80, dataIndex: 'businesscertificate'},
            {header: '经营许可证效期', width: 100, dataIndex: 'businesscertificateexpdate'},
            {header: '生产许可证号', width: 150, dataIndex: 'productionlicense'},

            {header: '生产许可证效期', width: 100, dataIndex: 'productionlicenseexpdate'},
            {header: '授权到期', width: 100, dataIndex: 'authorizationdate'},
            {header: '联系人', width: 150, dataIndex: 'contactperson'},
            {header: '电话', width: 150, dataIndex: 'contacttel'},
            {header: '备注', width: 150, dataIndex: 'remarks'}
		],
		title: '数据字典导入',
		frame: true
	});
