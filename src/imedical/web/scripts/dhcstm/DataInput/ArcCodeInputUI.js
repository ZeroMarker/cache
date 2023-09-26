// 数据字典导入(医嘱项)
var ArcCodeGrid = new Ext.grid.GridPanel({
		id: 'ArcCodeGrid',
		stripeRows: true,
		tbar: [{
				text: "删除",
				iconCls: 'page_delete',
				handler: function () {
					deleteDetail(ArcCodeGrid);
				}
			}, '-', {
				text: "清空数据",
				iconCls: 'page_clearscreen',
				handler: function () {
					clearData(ArcCodeGrid);
				}
			}, '-', {
				text: "导入",
				iconCls: 'page_add',
				handler: function () {
					SaveInci();
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
           {name:'feeuom'}, //计价单位
           {name:'sp',type: 'float'},
           {name:'rp',type: 'float'},
           {name:'ordcat'},  //医嘱大类

           {name:'ordsubcat'}, //医嘱子类
           {name:'billcat'},   //账单大类
           {name:'billsubcat'}, //账单子类
           {name:'tarcat'},     //收费大类
           {name:'tarsubcat'},  //收费子类

           {name:'inpacat'}, //住院大类
           {name:'inpasubcat'}, //住院子类
           {name:'outpacat'}, //门诊大类
           {name:'outpasubcat'}, //门诊子类
           {name:'emcat'}, //核算大类

           {name:'emsubcat'}, //核算子类
           {name:'acctcat'}, //会计大类
           {name:'acctsubcat'}, //会计子类
           {name:'mrcat'}, //病案大类
           {name:'mrsubcat'}, //病案子类

           {name:'mrsubcatnew'}, //新病案首页子类
           {name:'insucode'}, //医保编码
           {name:'insudesc'}, //医保描述
           {name:'priority'}, //医嘱优先级
           {name:'onitsown'}, //独立医嘱

           {name:'wostock'},  //无库存医嘱
           {name:'charge'}, //是否收费
           {name:'highvalue'}, //高值标志
           {name:'batrequired'},
           {name:'expdaterequired'},

           {name:'supervision'}, //监管级别
           {name:'barcode'}, //条码
           {name:'pbflag'}, //招标标志
           {name:'pbrp'}, //招标进价(按整包装单位计)
           {name:'vendor'}, //招标供应商名称

           {name:'manf'},  //招标生产商名称
           {name:'carrier'}, //招标配送商名称
           {name:'registerno'},//器械注册证号
           {name:'registerexpdate'},//器械注册证号效期
           {name:'productionlicense'},  //生产许可证号

           {name:'productionlicenseexpdate'}, //生产许可证效期
           {name:'businesslicense'}, //供应商营业执照号
           {name:'businesslicensedate'}, //供应商营业执照有效期
           {name:'revreg'}, // 供应商税务登记证号
           {name:'orgcode'}, //供应商组织机构代码

           {name:'orgcodedate'}, //供应商组织机构代码有效期
           {name:'businesscertificate'}, //供应商经营许可证号
           {name:'businesscertificateexpdate'}, //供应商经营许可证效期
           {name:'authorizationdate'}, //供应商授权截止日期
           {name:'contactperson'}, //contactperson

           {name:'contacttel'}, //授权联系人电话
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
            {header: '计价单位', width: 120,dataIndex: 'feeuom'},
            {header: '进价', width: 80, dataIndex: 'rp'},
            {header: '售价', width: 80, dataIndex: 'sp'},
            {header: '医嘱大类', width: 150, dataIndex: 'ordcat'},

            {header: '医嘱子类', width: 120, dataIndex: 'ordsubcat'},
            {header: '账单大类', width: 120, dataIndex: 'billcat'},
            {header: '账单子类', width: 120, dataIndex: 'billsubcat'},
            {header: '收费大类', width: 120, dataIndex: 'tarcat'},
            {header: '收费子类', width: 120, dataIndex: 'tarsubcat'},

            {header: '住院大类', width: 120, dataIndex: 'inpacat'},
            {header: '住院子类', width: 120, dataIndex: 'inpasubcat'},
            {header: '门诊大类', width: 120, dataIndex: 'outpacat'},
            {header: '门诊子类', width: 120, dataIndex: 'outpasubcat'},
            {header: '核算大类', width: 120, dataIndex: 'emcat'},

            {header: '核算子类', width: 120, dataIndex: 'emsubcat'},
            {header: '会计大类', width: 120, dataIndex: 'acctcat'},
            {header: '会计子类', width: 120, dataIndex: 'acctsubcat'},
            {header: '病案大类', width: 120, dataIndex: 'mrcat'},
            {header: '病案子类', width: 120, dataIndex: 'mrsubcat'},

            {header: '新病案首页子类', width: 120, dataIndex: 'mrsubcatnew'},
            {header: '医保编码', width: 120, dataIndex: 'insucode'},
            {header: '医保描述', width: 120, dataIndex: 'insudesc'},
            {header: '医嘱优先级', width: 120, dataIndex: 'priority'},
            {header: '独立医嘱', width: 120, dataIndex: 'onitsown'},

            {header: '无库存医嘱', width: 120,dataIndex: 'wostock'},
            {header: '是否收费', width: 120,dataIndex: 'charge'},
            {header: '是否高值', width: 150, dataIndex: 'highvalue'},
            {header: '是否需要批号', width: 50, dataIndex: 'batrequired'},
            {header: '是否需要效期', width: 50,dataIndex: 'expdaterequired'},

            {header: '监管级别', width: 120,dataIndex: 'supervision'},
            {header: '条码', width: 120,dataIndex: 'barcode'},
            {header: '招标标志(0,1)', width: 80,dataIndex: 'pbflag'},
            {header: '招标进价(按整包装单位计)', width:80,dataIndex: 'pbrp'},
            {header: '招标供应商名称', width: 120, dataIndex: 'vendor'},

            {header: '招标生产商名称', width: 120, dataIndex: 'manf'},
            {header: '招标配送商名称', width: 10, dataIndex: 'carrier'},
            {header: '器械注册证号', width: 120, dataIndex: 'registerno'},
            {header: '器械注册证效期', width: 80,dataIndex: 'registerexpdate'},
            {header: '生产许可证号', width: 120,dataIndex: 'productionlicense'},

            {header: '生产许可证效期', width: 80,dataIndex: 'productionlicenseexpdate'},
            {header: '供应商营业执照号', width: 120,dataIndex: 'businesslicense'},
            {header: '供应商营业执照有效期', width: 80, dataIndex: 'businesslicensedate'},
            {header: '供应商税务登记证号', width: 150, dataIndex: 'revreg'},
            {header: '供应商组织机构代码', width: 150, dataIndex: 'orgcode'},

            {header: '供应商组织机构代码有效期', width: 80, dataIndex: 'orgcodedate'},
            {header: '供应商经营许可证号', width: 120, dataIndex: 'businesscertificate'},
            {header: '供应商经营许可证效期', width: 80, dataIndex: 'businesscertificateexpdate'},
            {header: '供应商授权截止日期', width: 80, dataIndex: 'authorizationdate'},
            {header: '授权联系人', width: 100, dataIndex: 'contactperson'},

            {header: '授权联系人电话', width: 150, dataIndex: 'contacttel'},
            {header: '备注', width: 150, dataIndex: 'remarks'}
		],
		title: '数据字典导入(医嘱项)',
		frame: true
	});
