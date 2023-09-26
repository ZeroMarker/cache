// �����ֵ䵼��
var CodeGrid = new Ext.grid.GridPanel({
		id: 'CodeGrid',
		stripeRows: true,
		tbar: [{
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					deleteDetail(CodeGrid);
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					clearData(CodeGrid);
				}
			}, '-', {
				text: "����",
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
            {header: '����������', width: 120,dataIndex: 'catgrp'},
            {header: '�����������', width: 150, dataIndex: 'stkcat'},
            {header: '���ʴ���', width: 80, dataIndex: 'code'},
            {header: '����', width: 120,dataIndex: 'desc'},
            {header: '����ͺ�', width: 150, dataIndex: 'spec'},

            {header: 'Ʒ��', width: 80, dataIndex: 'brand'},
            {header: '���', width: 120,dataIndex: 'abbr'},
            {header: '����', width: 150, dataIndex: 'alias'},
            {header: '��С��λ', width: 80, dataIndex: 'buom'},
            {header: '����װ��λ', width: 120,dataIndex: 'puom'},

            {header: '����ת��ϵ��', width: 80, dataIndex: 'factor'},
            {header: '�ۼ�', width: 80, dataIndex: 'sp'},
            {header: '����', width: 80, dataIndex: 'rp'},
            {header: '�Ƿ��շ�', width: 120,dataIndex: 'charge'},
            {header: '�Ƿ��ֵ', width: 150, dataIndex: 'highvalue'},

            {header: '�Ƿ���Ҫ����', width: 80, dataIndex: 'batrequired'},
            {header: '�Ƿ���ҪЧ��', width: 120,dataIndex: 'expdaterequired'},
            {header: '��Ӧ������', width: 150, dataIndex: 'vendor'},
            {header: '������������', width: 80, dataIndex: 'manf'},
            {header: '��еע��֤��', width: 80, dataIndex: 'registerno'},

            {header: '��еע��֤Ч��', width: 120,dataIndex: 'registerexpdate'},
            {header: 'Ӫҵִ�պ�', width: 150, dataIndex: 'businesslicense'},
            {header: '��Ӫ���֤��', width: 80, dataIndex: 'businesscertificate'},
            {header: '��Ӫ���֤Ч��', width: 100, dataIndex: 'businesscertificateexpdate'},
            {header: '�������֤��', width: 150, dataIndex: 'productionlicense'},

            {header: '�������֤Ч��', width: 100, dataIndex: 'productionlicenseexpdate'},
            {header: '��Ȩ����', width: 100, dataIndex: 'authorizationdate'},
            {header: '��ϵ��', width: 150, dataIndex: 'contactperson'},
            {header: '�绰', width: 150, dataIndex: 'contacttel'},
            {header: '��ע', width: 150, dataIndex: 'remarks'}
		],
		title: '�����ֵ䵼��',
		frame: true
	});
