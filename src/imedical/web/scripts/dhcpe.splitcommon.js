/**
 * Description: 拖动拆分界面 
 * FileName: dhcpe.splitcommon.js
 * Creator: wangguoying
 * Date: 2023-04-14
 */
/**
 * [初始化拖放事件]  
 * @Author wangguoying
 * @Date 2023-04-17
 */
function init_drag_event() {
    $('.dragable').draggable({
        proxy: 'clone',
        revert: true,
        cursor: 'Move',
        onStartDrag: function() {
            $(this).draggable('options').cursor = 'not-allowed';
            $(this).draggable('proxy').addClass('dp');
        },
        onStopDrag: function() {
            $(this).draggable('options').cursor = 'auto';
        }
    });
    $('.droppable').droppable({
        onDragEnter: function(e, source) {
            if ($(this).find("Ur").attr("id") == source.parentNode.id) return false;
            $(source).draggable('options').cursor = 'auto';
            $(source).draggable('proxy').css('border', '1px solid red');
            $(this).addClass('over');
        },
        onDragLeave: function(e, source) {
            if ($(this).find("Ur").attr("id") == source.parentNode.id) return false;
            $(source).draggable('options').cursor = 'not-allowed';
            $(source).draggable('proxy').css('border', '1px solid #ccc');
            $(this).removeClass('over');
        },
        onDrop: function(e, source) {
            if ($(this).find("Ur").attr("id") == source.parentNode.id) return false;
            $(source).draggable('options').cursor = 'Move';
            $(this).find("Ur").append(source);
            $(this).removeClass('over');
        }
    });
}

$(init_drag_event);