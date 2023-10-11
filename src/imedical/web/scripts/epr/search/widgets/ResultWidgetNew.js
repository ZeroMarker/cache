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
                
                FullTextSearch.FavorMREpisodeID = mrEpisodeID;
                FullTextSearch.FavorMRVerItemID = mrVerItemID;
                
                $('#saveWin').dialog('open');
                $('#name').val(mrItemName);
                var queryInput = $('#saveQuery').val();
                $('#tags').val(queryInput);
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
            output += '<div class="docHeader"><a href="' + cspBaseUrl + 'dhc.epr.search.pdfview4chrome.csp?DataServiceUrl=' + dataServiceUrl + '&MREpisodeID=' + doc.MREpisodeID + '&MRVerItemsIDs=' + doc.id + '" target="_blank">' + doc.MRItemName + '</a></div>';
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