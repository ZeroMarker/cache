
 //ParticipantsInfoList = function(participantsdrs){

	var ParticipantsInfoGrid = new dhc.herp.Grid({
				//title : "���������Ա��Ϣ",
				region : 'center',                          
        url : 'herp.srm.srmprojectsapplyexe.csp',
				fields : [
              new Ext.grid.CheckboxSelectionModel({editable:false}),
           {
							id : 'Name',
							header : '����',
							dataIndex : 'Name',
							width : 120,
							align : 'center',
							editable:false
						}, {
							id : 'CreditID',
							header : '���֤��',
							dataIndex : 'CreditID',
							width : 120,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'BirthDay',
							header : '��������',
							dataIndex : 'BirthDay',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Sex',
							header : '�Ա�',
							dataIndex : 'Sex',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'TitleInfo',
							header : 'ְ��',
							dataIndex : 'TitleInfo',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Degree',
							header : 'ѧλ',
							dataIndex : 'Degree',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Dept',
							header : '����רҵ',
							dataIndex : 'Dept',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Comp',
							header : '��λ����',
							dataIndex : 'Comp',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Tel',
							header : '�绰',
							dataIndex : 'Tel',
							width : 120,
              editable:false,
							align : 'center'
						}, {
							id : 'Email',
							header : '��������',
							dataIndex : 'Email',
							width : 120,
              editable:false,
							align : 'center'
						}]    
			});
// }
		  ParticipantsInfoGrid.btnAddHide();  //�������Ӱ�ť
	   	ParticipantsInfoGrid.btnSaveHide();  //���ر��水ť
	    ParticipantsInfoGrid.btnResetHide();  //�������ð�ť
	    ParticipantsInfoGrid.btnDeleteHide(); //����ɾ����ť
	    ParticipantsInfoGrid.btnPrintHide();  //���ش�ӡ��ť
    
