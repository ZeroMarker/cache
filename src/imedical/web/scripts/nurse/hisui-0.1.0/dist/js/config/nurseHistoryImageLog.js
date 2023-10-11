/*
 * @author: yaojining
 * @discription: ��������ʷͼƬ������־
 * @date: 2021-7-29
 */
$(function () {
	initUI();
});
/**
* @description: ��ʼ������
*/
function initUI() {
	LoadImageLogGrid();
}

/**
 * @description ����ͼƬ��ʷ��־���
 */
function LoadImageLogGrid(){
	$HUI.datagrid('#ImageLogGrid', {
		url: $URL,
		columns: [[
            { field: 'StartDate', title: '��ʼ����', width: 130, align: 'center'},
	        { field: 'EndDate', title: '��������', width: 130, align: 'center' },
	        { field: 'PrnCode', title: '��ӡģ��', width: 300, align: 'center' },
        ]],
		queryParams: {
			ClassName: "NurMp.Print.NurseHistoryImage",
			QueryName: "FindLog",
			Code: Code
		},
		nowrap:false,
		pagination: true,
		pageSize: 10,
		pageList: [10, 50, 100]
	});
}
