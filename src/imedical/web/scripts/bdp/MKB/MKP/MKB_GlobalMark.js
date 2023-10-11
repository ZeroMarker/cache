/*
 * @Author: 基础数据平台-范文凯
 * @Date:   2020-03-15
 * @Last Modified by:   admin
 * @Last Modified time: 2020-03-15
 * @描述:全局化词表标记
 */
var init = function() {
	 var columns = [
            [{
                field: 'MKBTRowId',
                title: 'MKBTRowId',
                width: 80,
                sortable: true,
                hidden: true
            }, {
                field: 'MKBTDesc',
                title: '中心词',
                width: 200,
                sortable: true
            }, {
                field: 'MKBTSequence',
                title: '顺序',
                width: 150,
                sortable: true,
                hidden: true
            }, {
                field: 'MKBTLastLevel',
                title: '上级节点',
                width: 80,
                hidden: true
            }]
        ];
    var marktreegrid = $('#marktreegrid').treegrid({
        url: "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTreeJson&base=111",
        columns: columns, //列信息
        height: $(window).height() - 105, ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
        idField: 'MKBTRowId',
        treeField: 'MKBTDesc', //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
        autoSizeColumn: false,
        scrollbarSize: 8,
        //ClassTableName: 'User.MKBTermT26',
        //SQLTableName: 'MKB_TermT26',
        toolbar:'#markTools',
        animate: false, //是否树展开折叠的动画效果
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort: false, //定义是否从服务器排序数据。true
        checkbox:true,
        onlyLeafCheck:true,
        cascadeCheck:false,
        onLoadSuccess: function(data) {
            if (GlobalID!="")
            {
               var tkresult = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "GetMarkIDStr", GlobalID)
               var markIDArray = tkresult.split(",");
               for  (var i = 0; i < markIDArray.length; i++) {
                  // MarkArry.push(markIDArray[i].MKBTDesc)
                  $("#marktreegrid").treegrid("checkNode",markIDArray[i]);
               }
            }
        },
    });
    $('#marksave_btn').click(function(e) {
    	var records = $('#marktreegrid').treegrid('getCheckedNodes');
    	var MarkArry = [];
        for (var i = 0; i < records.length; i++) {
            MarkArry.push(records[i].MKBTDesc)
        }
        var MarkStr = MarkArry.join(",");
        var result = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "SaveMKBGMark", GlobalID,MarkStr);
        if (result="yes")
        {
           $.messager.popover({
                        msg: '保存成功!',
                        type: 'success',
                        timeout: 1000
           });
           $('#marktreegrid').treegrid('reload');
        }
    })
}
$(init);