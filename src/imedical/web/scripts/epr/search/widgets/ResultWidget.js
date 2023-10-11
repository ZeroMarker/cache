(function($) {
    AjaxSolr.ResultWidget = AjaxSolr.AbstractWidget.extend({
        start: 0,

        beforeRequest: function() {
            //获得结果前加载等待图片
            $(this.target).html($('<img>').attr('src', '../scripts/epr/search/images/ajax-loader.gif'));
        },

        afterRequest: function() {
            //debugger;

            $(this.target).empty();
            //$(this.target).append('<div id="saveWin"></div>');

            //取得查询结果的json        
            for (var i = 0, l = this.manager.response.response.docs.length; i < l; i++) {
                var doc = this.manager.response.response.docs[i];
                //debugger;
                //高亮
                if ((this.manager.response.highlighting != null) && (doc.id != null)) {
                    var highlightingOne = this.manager.response.highlighting[doc.id];
                    if (highlightingOne != null && highlightingOne["contentComplex"] != null) {
                        var highlightingOneContent = highlightingOne["contentComplex"][0];
                        doc.contentComplex = highlightingOneContent;
                    }
                }

                $(this.target).append(this.template(doc));
            }

            $('.AHref').on('click', function() {
                var mrVerItemID = $(this).attr("mrVerItemID");
                var mrEpisodeID = $(this).attr("mrEpisodeID");
                var mrItemName = $(this).attr("mrItemName");

                var html = "";
                html += '<div class="easyui-panel" id="savePanel"><div style="padding:10px 10px 10px 10px">';
                html += '<form id="saveForm" method="post">';
                html += '<table cellpadding="5">';
                html += '<tr><td class="label">名称:</td><td><input type="text" class="inputClass" id="name" name="name" /></td></tr>';
                html += '<tr><td class="label">分类:</td><td><input type="text" class="inputClass" id="category" name="category" /></td></tr>';
                html += '<tr><td class="label">标签:</td><td><input type="text" class="inputClass" id="tags" name="tags" /></td></tr>';
                html += '<tr><td class="label">备注:</td><td><textarea class="textareaClass" id="notes" name="notes"></textarea></td></tr>';
                html += '<tr><td calss="label"></td><td>';
                html += '<div style="text-align:center;padding:5px">';
                html += '<a href="#" class="inputButton" id="saveFormButton">保存</a>';
                html += '<a href="#" class="inputButton" id="clearFormButton">清空</a>';
                html += '<a href="#" class="inputButton" id="cancelFormButton">取消</a>';
                html += '</div></td></tr>';
                html += '</table>';
                html += '</form></div></div>';

                $('#saveWin').empty();
                $('#saveWin').append(html);

                $('#saveWin').window({
                    width: 400,
                    height: 350,
                    modal: true,
                    collapsible: false,
                    minimizable: false,
                    maximizable: false,
                    closable: true,
                    title: '确定收藏'
                });

                $('#name').val(mrItemName);
                var queryInput = $('#saveQuery').val();
                $('#tags').val(queryInput);

                $('#saveFormButton').on('click', function() {
                    var url = '../DHCEPRSearch.web.eprajax.AjaxFavorites.cls';
                    url += '?Action=add';
                    url += '&MREpisodeID=' + mrEpisodeID;
                    url += '&MRVerItemsID=' + mrVerItemID;
                    url += '&UserID=' + userID;
                    url += '&DocName=' + $('#name').val();
                    url += '&Notes=' + $('#notes').val();
                    url += '&Tags=' + $('#tags').val();

                    url = encodeURI(url);

                    var obj = $.ajax({
                        url: url,
                        method: 'post',
                        async: false,
                        success: function(data) {
                            if (parseInt(data) >= 1) {
                                $.messager.alert('提示', '收藏成功', 'info', function(data) {
                                    $('#saveWin').window('close');
                                });
                            }
                            else {
                                $.messager.alert('提示', '收藏失败，请重新尝试', 'error', function(data) {
                                    $('#saveWin').window('close');
                                });
                            }
                        }
                    });
                });

                $('#cancelFormButton').on('click', function() {
                    $('#saveWin').window('close');
                });

                $('#clearFormButton').on('click', function() {
                    $('#name').val("");
                    $('#notes').val("");
                    $('#tags').val("");
                    $('#category').val("");
                });

            });
        },

        template: function(doc) {
            //每一条结果显示在前台的格式
            var snippet = '';
            var docContent = doc.contentComplex.toString();

            docContent = docContent.replace(/&amp;nbsp;/g, " ");
            docContent = docContent.replace(/&nbsp;/g, " ");
            docContent = docContent.replace(/&amp;KeyEnter;/g, " ");
            docContent = docContent.replace(/&KeyEnter;/g, " ");

            snippet += docContent;

            var output = '<div class="divDoc">';
            //标题，跳转链接
            //output += '<div class="docHeader"><h2><a href="' + cspBaseUrl + 'dhc.epr.search.pdfview.csp?DataServiceUrl=' + dataServiceUrl + '&MREpisodeID=' + doc.MREpisodeID + '&MRVerItemsIDs=' + doc.id + '" target="_blank">' + doc.MRItemName + '</a></h2></div>';
            output += '<div class="docHeader"><h2><a href="' + cspBaseUrl + 'dhc.epr.search.pdfview4chrome.csp?MREpisodeID=' + doc.MREpisodeID + '&MRVerItemsIDs=' + doc.id + '" target="_blank">' + doc.MRItemName + '</a></h2></div>';
            //高亮的内容简要
            output += '<div class="docContentHightlight"><p>' + snippet + '</p></div>';
            //文档的具体信息
            output += '<div class="docProperty">' + '文档类型：' + doc.MRItemName + ' | 入院科室：' + doc.AdmLoc + ' | 出院科室：' + doc.DisLoc + ' |  病案号：' + doc.MedRecordNo;
            output += '<a href="#" id="AHref' + doc.id + '" class="AHref" mrItemName="' + doc.MRItemName + '" mrEpisodeID="' + doc.MREpisodeID + '" mrVerItemID="' + doc.id + '">收藏</a>';
            output += '</div>';
            output += '</div><br>';
            return output;
        },

        init: function() {
            $(document).on('click', 'a.more', function() {
                //debugger;
                var $this = $(this);
                var span = $this.parent().find('span');

                if (span.is(':visible')) {
                    span.hide();
                    $this.text('更多');
                }
                else {
                    span.show();
                    $this.text('收回');
                }

                return false;
            });
        }
    });

})(jQuery);