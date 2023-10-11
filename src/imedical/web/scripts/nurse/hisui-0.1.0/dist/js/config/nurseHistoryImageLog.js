/*
 * @author: yaojining
 * @discription: 护理病历历史图片生成日志
 * @date: 2021-7-29
 */
$(function () {
	initUI();
});
/**
* @description: 初始化界面
*/
function initUI() {
	LoadImageLogGrid();
}

/**
 * @description 加载图片历史日志表格
 */
function LoadImageLogGrid(){
	$HUI.datagrid('#ImageLogGrid', {
		url: $URL,
		columns: [[
            { field: 'StartDate', title: '开始日期', width: 130, align: 'center'},
	        { field: 'EndDate', title: '结束日期', width: 130, align: 'center' },
	        { field: 'PrnCode', title: '打印模板', width: 300, align: 'center' },
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
