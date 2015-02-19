/**
 * A bunch of JS helpers for the site.
 * Also includes using Noty to override any alerts, etc.
 */
// String.format .NET style
if (!String.prototype.format) {
    String.prototype.format = function () {
        var args = arguments;
        return this.replace(/{(\d+)}/g, function (match, number) {
            return typeof args[number] != 'undefined'
              ? args[number]
              : match
            ;
        });
    };
}

// String.endsWith
String.prototype.endsWith = function (suffix) {
    return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

// Alerts and noty
function alert(message) {
    alert(message, false);
}

function alert(message, timeout) {
    alert(message, false);
}

function error(message) {
    alert(message, true);
}

function alert(message, isError) {
    var type = '';
    var timeoutTime = 5000;

    if (isError) {
        type = 'error';
        timeoutTime = 60000;
    } else {
        type = 'alert';
    }

    var note = noty({
        text: message,
        type: type,
        timeout: true,
        template: '<div class="noty_message" id="notification"><span class="noty_text"></span><div class="noty_close"></div></div>'
    }).setTimeout(timeoutTime);
}

function confirm(message, onYes) {
    var n = noty({
        text: message,
        type: 'confirm',
        dismissQueue: false,
        layout: 'top',
        buttons:
        [
            {
                addClass: 'btn',
                id: 'confirm-yes',
                text: 'Yes',
                onClick: function($noty) {
                    // this = button element
                    // $noty = $noty element
                    $noty.close();
                    if (onYes != null) {
                        onYes();
                    }
                }
            },
            {
                addClass: 'btn',
                id: 'confirm-no',
                text: 'No',
                onClick: function ($noty) {
                    $noty.close();
                }
            }
        ]
    })
}