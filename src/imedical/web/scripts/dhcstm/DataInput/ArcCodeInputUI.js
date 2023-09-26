// �����ֵ䵼��(ҽ����)
var ArcCodeGrid = new Ext.grid.GridPanel({
		id: 'ArcCodeGrid',
		stripeRows: true,
		tbar: [{
				text: "ɾ��",
				iconCls: 'page_delete',
				handler: function () {
					deleteDetail(ArcCodeGrid);
				}
			}, '-', {
				text: "�������",
				iconCls: 'page_clearscreen',
				handler: function () {
					clearData(ArcCodeGrid);
				}
			}, '-', {
				text: "����",
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
           {name:'feeuom'}, //�Ƽ۵�λ
           {name:'sp',type: 'float'},
           {name:'rp',type: 'float'},
           {name:'ordcat'},  //ҽ������

           {name:'ordsubcat'}, //ҽ������
           {name:'billcat'},   //�˵�����
           {name:'billsubcat'}, //�˵�����
           {name:'tarcat'},     //�շѴ���
           {name:'tarsubcat'},  //�շ�����

           {name:'inpacat'}, //סԺ����
           {name:'inpasubcat'}, //סԺ����
           {name:'outpacat'}, //�������
           {name:'outpasubcat'}, //��������
           {name:'emcat'}, //�������

           {name:'emsubcat'}, //��������
           {name:'acctcat'}, //��ƴ���
           {name:'acctsubcat'}, //�������
           {name:'mrcat'}, //��������
           {name:'mrsubcat'}, //��������

           {name:'mrsubcatnew'}, //�²�����ҳ����
           {name:'insucode'}, //ҽ������
           {name:'insudesc'}, //ҽ������
           {name:'priority'}, //ҽ�����ȼ�
           {name:'onitsown'}, //����ҽ��

           {name:'wostock'},  //�޿��ҽ��
           {name:'charge'}, //�Ƿ��շ�
           {name:'highvalue'}, //��ֵ��־
           {name:'batrequired'},
           {name:'expdaterequired'},

           {name:'supervision'}, //��ܼ���
           {name:'barcode'}, //����
           {name:'pbflag'}, //�б��־
           {name:'pbrp'}, //�б����(������װ��λ��)
           {name:'vendor'}, //�б깩Ӧ������

           {name:'manf'},  //�б�����������
           {name:'carrier'}, //�б�����������
           {name:'registerno'},//��еע��֤��
           {name:'registerexpdate'},//��еע��֤��Ч��
           {name:'productionlicense'},  //�������֤��

           {name:'productionlicenseexpdate'}, //�������֤Ч��
           {name:'businesslicense'}, //��Ӧ��Ӫҵִ�պ�
           {name:'businesslicensedate'}, //��Ӧ��Ӫҵִ����Ч��
           {name:'revreg'}, // ��Ӧ��˰��Ǽ�֤��
           {name:'orgcode'}, //��Ӧ����֯��������

           {name:'orgcodedate'}, //��Ӧ����֯����������Ч��
           {name:'businesscertificate'}, //��Ӧ�̾�Ӫ���֤��
           {name:'businesscertificateexpdate'}, //��Ӧ�̾�Ӫ���֤Ч��
           {name:'authorizationdate'}, //��Ӧ����Ȩ��ֹ����
           {name:'contactperson'}, //contactperson

           {name:'contacttel'}, //��Ȩ��ϵ�˵绰
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
            {header: '�Ƽ۵�λ', width: 120,dataIndex: 'feeuom'},
            {header: '����', width: 80, dataIndex: 'rp'},
            {header: '�ۼ�', width: 80, dataIndex: 'sp'},
            {header: 'ҽ������', width: 150, dataIndex: 'ordcat'},

            {header: 'ҽ������', width: 120, dataIndex: 'ordsubcat'},
            {header: '�˵�����', width: 120, dataIndex: 'billcat'},
            {header: '�˵�����', width: 120, dataIndex: 'billsubcat'},
            {header: '�շѴ���', width: 120, dataIndex: 'tarcat'},
            {header: '�շ�����', width: 120, dataIndex: 'tarsubcat'},

            {header: 'סԺ����', width: 120, dataIndex: 'inpacat'},
            {header: 'סԺ����', width: 120, dataIndex: 'inpasubcat'},
            {header: '�������', width: 120, dataIndex: 'outpacat'},
            {header: '��������', width: 120, dataIndex: 'outpasubcat'},
            {header: '�������', width: 120, dataIndex: 'emcat'},

            {header: '��������', width: 120, dataIndex: 'emsubcat'},
            {header: '��ƴ���', width: 120, dataIndex: 'acctcat'},
            {header: '�������', width: 120, dataIndex: 'acctsubcat'},
            {header: '��������', width: 120, dataIndex: 'mrcat'},
            {header: '��������', width: 120, dataIndex: 'mrsubcat'},

            {header: '�²�����ҳ����', width: 120, dataIndex: 'mrsubcatnew'},
            {header: 'ҽ������', width: 120, dataIndex: 'insucode'},
            {header: 'ҽ������', width: 120, dataIndex: 'insudesc'},
            {header: 'ҽ�����ȼ�', width: 120, dataIndex: 'priority'},
            {header: '����ҽ��', width: 120, dataIndex: 'onitsown'},

            {header: '�޿��ҽ��', width: 120,dataIndex: 'wostock'},
            {header: '�Ƿ��շ�', width: 120,dataIndex: 'charge'},
            {header: '�Ƿ��ֵ', width: 150, dataIndex: 'highvalue'},
            {header: '�Ƿ���Ҫ����', width: 50, dataIndex: 'batrequired'},
            {header: '�Ƿ���ҪЧ��', width: 50,dataIndex: 'expdaterequired'},

            {header: '��ܼ���', width: 120,dataIndex: 'supervision'},
            {header: '����', width: 120,dataIndex: 'barcode'},
            {header: '�б��־(0,1)', width: 80,dataIndex: 'pbflag'},
            {header: '�б����(������װ��λ��)', width:80,dataIndex: 'pbrp'},
            {header: '�б깩Ӧ������', width: 120, dataIndex: 'vendor'},

            {header: '�б�����������', width: 120, dataIndex: 'manf'},
            {header: '�б�����������', width: 10, dataIndex: 'carrier'},
            {header: '��еע��֤��', width: 120, dataIndex: 'registerno'},
            {header: '��еע��֤Ч��', width: 80,dataIndex: 'registerexpdate'},
            {header: '�������֤��', width: 120,dataIndex: 'productionlicense'},

            {header: '�������֤Ч��', width: 80,dataIndex: 'productionlicenseexpdate'},
            {header: '��Ӧ��Ӫҵִ�պ�', width: 120,dataIndex: 'businesslicense'},
            {header: '��Ӧ��Ӫҵִ����Ч��', width: 80, dataIndex: 'businesslicensedate'},
            {header: '��Ӧ��˰��Ǽ�֤��', width: 150, dataIndex: 'revreg'},
            {header: '��Ӧ����֯��������', width: 150, dataIndex: 'orgcode'},

            {header: '��Ӧ����֯����������Ч��', width: 80, dataIndex: 'orgcodedate'},
            {header: '��Ӧ�̾�Ӫ���֤��', width: 120, dataIndex: 'businesscertificate'},
            {header: '��Ӧ�̾�Ӫ���֤Ч��', width: 80, dataIndex: 'businesscertificateexpdate'},
            {header: '��Ӧ����Ȩ��ֹ����', width: 80, dataIndex: 'authorizationdate'},
            {header: '��Ȩ��ϵ��', width: 100, dataIndex: 'contactperson'},

            {header: '��Ȩ��ϵ�˵绰', width: 150, dataIndex: 'contacttel'},
            {header: '��ע', width: 150, dataIndex: 'remarks'}
		],
		title: '�����ֵ䵼��(ҽ����)',
		frame: true
	});
