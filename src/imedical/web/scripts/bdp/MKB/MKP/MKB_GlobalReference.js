/// 名称: 医用知识库 -全局化词表-引用列表展示
/// 描述: 包含增删改查功能
/// 编写者: 基础数据平台组-范文凯
/// 编写日期: 2019-10-18
var init = function() {
    var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBGlobal&pClassMethod=DeleteReferenceData";
    var editIndex = undefined; //正在编辑的行index
    var rowsvalue = undefined; //正在编辑的行数据
    var referencecolumns = [
        [{
            field: 'MKBGRRowId',
            title: 'RowId',
            hidden: true,
            width: 100,
            resizable: true
        }, {
            field: 'MKBGRCode',
            title: '代码',
            width: 100,
            hidden: true,
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGRCode+'">'+value+'</span>'
            } //注意tooltip标签与分词标记区分，分词点击事件有冲突
        }, {
            field: 'MKBGRDesc',
            title: '中心词',
            hidden: false,
            width: 100,
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGRDesc+'">'+value+'</span>'
            } //注意tooltip标签与分词标记区分，分词点击事件有冲突
        }, {
            field: 'MKBGRType',
            title: '所属类型',
            hidden: false,
            width: 100,
	    hidden: true
        }, {
            field: 'MKBGRLevel',
            title: '所属层级',
            hidden: false,
            width: 150,
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGRLevel+'">'+value+'</span>'
            } //注意tooltip标签与分词标记区分，分词点击事件有冲突
        },{
            field: 'MKBGRLastLevel',
            title: '上级节点',
            hidden:false,
            width: 150,
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGRLastLevel+'">'+value+'</span>'
            } //注意tooltip标签与分词标记区分，分词点击事件有冲突
            },{
            field: 'MKBGRPYCode',
            title: '检索码',
            hidden: true,
            width: 100
        }, {
            field: 'MKBGRNote',
            title: '备注',
            hidden: true,
            width: 100,
            formatter:function(value,row,index){
                return '<span class="hisui-tooltip" title="'+row.MKBGRNote+'">'+value+'</span>'
              } //注意tooltip标签与分词标记区分，分词点击事件有冲突
        }]
    ];
    var referencelist = $("#referencecenterlistgrid").datagrid({
        url: $URL, //QUERY_ACTION_URL
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBGlobal",
            QueryName: "GetReferenceList",
            'GlobalRowId': GlobalID
        },
        columns: referencecolumns, //列信息
        singleSelect: true,
        rownumbers: false, //设置为 true，则显示带有行号的列。
        fixRowNumber: true,
        fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        toolbar: '#referenceTools',
        scrollbarSize: 0,
    })
    //跳转按钮
    $("#referencego_btn").click(function (e) { 
        var data=$('#referencecenterlistgrid').datagrid('getSelected')
        var referenceid = data.MKBGRRowId
        // 拿id去取termid
        var termid  = tkMakeServerCall("web.DHCBL.MKB.MKBGlobal", "Returntermid" , referenceid)
        //alert(termid)
        if(termid==""||termid==undefined){
            $.messager.alert('错误提示','请先选择一条诊断记录!',"error");
        }else{      
            var menuid=tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm.SY000059");
            var parentid="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetID","dhc.bdp.mkb.mtm");
            var menuimg="" //tkMakeServerCall("web.DHCBL.BDP.BDPMenuDefine","GetIconByID",menuid);
            //判断浏览器版本
            var Sys = {};
            var ua = navigator.userAgent.toLowerCase();
            var s;
            (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
            (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
            (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
            (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
            (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
            //双击时跳转到对应界面
            //if(!Sys.ie){
                window.parent.parent.closeNavTab(menuid)
                window.parent.parent.showNavTab(menuid,"主要部位测试",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",parentid,menuimg)
            //}else{
            //  parent.PopToTab(menuid,"临床实用诊断",'dhc.bdp.ext.sys.csp?BDPMENU='+menuid+"&TermID="+termid+"&ProId=",menuimg);
        //  }
        }   
    })  
    //引用删除按钮
    $("#referencedel_btn").click(function(e) {
        DelReference();
    })
    DelReference = function() {
        var record = $("#referencecenterlistgrid").datagrid("getSelected");
        if (!(record)) {
            $.messager.alert('错误提示', '请先选择一条记录!', "error");
            return;
        }
        if ((record.MKBGRRowId == undefined) || (record.MKBGRRowId == "")) {
            referencelist.deleteRow(editIndex)
            editIndex = undefined;
            return;
        }
        $.messager.confirm('提示', '确定要删除所选的数据吗?', function(r) {
            if (r) {
                $.ajax({
                    url: DELETE_ACTION_URL,
                    data: {
                        "Id": record.MKBGRRowId ///rowid
                    },
                    type: "POST",
                    success: function(data) {
                        var data = eval('(' + data + ')');
                        if (data.success == 'true') {
                            $.messager.popover({
                                msg: '删除成功！',
                                type: 'success',
                                timeout: 1000
                            });
                            $('#referencecenterlistgrid').datagrid('reload'); // 重新载入当前页面数据  
                            $('#referencecenterlistgrid').datagrid('unselectAll'); // 清空列表选中数据
                            editIndex = undefined;
                            rowsvalue = undefined;
                        } else {
                            var errorMsg = ""
                            if (data.info) {
                                errorMsg = '删除失败！<br/>错误信息:' + data.info
                                $.messager.alert('操作提示', errorMsg, "error");
                            }
                        }
                    }
                })
            }
        });
    }
};
$(init);