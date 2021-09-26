namespace Model {
    public class Normal {
        public int64 id { get; set; }
        public string pictureUrl { get; set; }
        public string json_string {     
            owned get {
                return @"{\"id\": $(id), \"picture_url\": \"$(pictureUrl)\"}";
            }
        }

        public Normal (int64 id, string pictureUrl) {
            _id = id;
            _pictureUrl = pictureUrl;
        }

        public static Normal? from_json_node (Json.Node json_node) {
            if (json_node.get_object ().has_member ("normal")) {
                message("has member normal");
                var json_normal = json_node.get_object ().get_object_member ("normal");
                return new Normal(
                    json_normal.get_int_member ("id"),
                    json_normal.get_string_member ("picture_url")
                );
            }
            return null;
        }

        public Json.Node to_json_node () {
            var node = new Json.Node (Json.NodeType.OBJECT);
            var json_obj = new Json.Object ();
            json_obj.set_int_member ("id", _id);
            json_obj.set_string_member ("picture_url", _pictureUrl);
            node.set_object (json_obj);
            return node;
        }
    }

    public class Slideshow {
        public int64 id { get; private set; }
        public List <weak string> pictureFiles { get; }
        public int64 startTime { get; private set; }
        public int64 interval { get; private set; }
        public string latestPicture { get; private set; }
        public string json_string {     
            owned get {
                var json_string = new StringBuilder();
                
                json_string.append("{");
                json_string.append(@"\"id\": $(_id),");
                json_string.append("\"picture_files\":");
                    json_string.append ("[");
                        for (int index = 0; index < _pictureFiles.length(); index++) {
                            json_string.append(@"\"$(_pictureFiles.nth(index).data)\"");
                            if (index < _pictureFiles.length() - 1) {
                                json_string.append (",");
                            }
                        }
                    json_string.append ("],");
                json_string.append(@"\"start_time\": $(_startTime),");
                json_string.append(@"\"interval\": $(interval),");
                json_string.append(@"\"latest_picture\": \"$(_latestPicture)\"");
                json_string.append("}");

                return json_string.str;
            }
        }

        public static Slideshow? from_json_node (Json.Node json_node) {
            if (json_node.get_object ().has_member ("slideshow")) {
                message("has member slideshow");
                var json_slideshow = json_node.get_object ().get_object_member ("slideshow");
                var json_pic_files = json_slideshow.get_array_member ("picture_files");
                var list_pic_files = new List<weak string> ();

                json_pic_files.foreach_element ((array, index, picture) => {
                    list_pic_files.append (picture.get_string ());
                });

                return new Slideshow(
                    json_slideshow.get_int_member ("id"),
                    list_pic_files,
                    json_slideshow.get_int_member ("start_time"),
                    json_slideshow.get_int_member ("interval"),
                    json_slideshow.get_string_member ("latest_picture")
                );
            }
            return null;
        }

        public Slideshow (
            int64 id,
            List <weak string> pictureFiles,
            int64 startTime,
            int64 interval,
            string latestPicture
        ) {
            _id = id;
            _pictureFiles = pictureFiles.copy();
            _startTime = startTime;
            _interval = interval;
            _latestPicture = latestPicture;
        }

        public Json.Node to_json_node () {
            var node = new Json.Node (Json.NodeType.OBJECT);
            var json_obj = new Json.Object ();

            json_obj.set_int_member ("id", _id);
            json_obj.set_int_member ("start_time", _startTime);
            json_obj.set_int_member ("interval", _interval);
            json_obj.set_string_member ("latest_picture", _latestPicture);
            
            var json_array = new Json.Array ();
            _pictureFiles.foreach ((e) => {
                json_array.add_string_element (e);
            });

            json_obj.set_array_member ("picture_files", json_array);
            node.set_object (json_obj);
            return node;
        }
    }

    public class DayNight {
        public int64 id { get; set; }
        public string dayPicture { get; set; }
        public string nightPicture { get; set; }
        public List <weak int> scheduleDay { get; }
        public List <weak int> scheduleNight { get; }
        public string json_string {
            owned get {
                var json_string = new StringBuilder ();

                json_string.append("{");
                json_string.append(@"\"id\": $(_id),");
                json_string.append(@"\"day_picture\": \"$(_dayPicture)\",");
                json_string.append(@"\"night_picture\": \"$(_nightPicture)\",");
                json_string.append("\"schedule_day\":");
                    json_string.append ("[");
                    for (int index = 0; index < _scheduleDay.length(); index++) {
                        json_string.append(@"$(_scheduleDay.nth(index).data)");
                        if (index < _scheduleDay.length() - 1) {
                            json_string.append (",");
                        }
                    }
                    json_string.append ("],");
                json_string.append("\"schedule_night\":");
                    json_string.append ("[");
                    for (int index = 0; index < _scheduleNight.length(); index++) {
                        json_string.append(@"$(_scheduleNight.nth(index).data)");
                        if (index < _scheduleNight.length() - 1) {
                            json_string.append (",");
                        }
                    }
                    json_string.append ("]");
                json_string.append("}");

                return json_string.str;
            }
        }

        public DayNight (
            int64 id,
            string dayPicture,
            string nightPicture,
            List <int> scheduleDay,
            List <int> scheduleNight
        ) {
            _id = id;
            _dayPicture = dayPicture;
            _nightPicture = nightPicture;
            _scheduleDay = scheduleDay.copy();
            _scheduleNight = scheduleNight.copy();
        }

        public static DayNight? from_json_node (Json.Node json_node) {
            if (json_node.get_object ().has_member ("daynight")) {
                message("has member daynight");
                var json_daynight = json_node.get_object ().get_object_member ("daynight");
                var json_schedule_day = json_daynight.get_array_member ("schedule_day");
                var json_schedule_night = json_daynight.get_array_member ("schedule_night");

                var list_schedule_day = new List<int> ();
                var list_schedule_night = new List<int> ();

                json_schedule_day.foreach_element ((array, index, hour) => {
                    list_schedule_day.append (
                        int.parse (hour.get_int ().to_string ())
                    );
                });

                json_schedule_night.foreach_element ((array, index, hour) => {
                    list_schedule_night.append (
                        int.parse (hour.get_int ().to_string ())
                    );
                });

                return new DayNight (
                    json_daynight.get_int_member ("id"), 
                    json_daynight.get_string_member ("day_picture"), 
                    json_daynight.get_string_member ("night_picture"), 
                    list_schedule_day, 
                    list_schedule_night
                );
            }
            return null;
        }

        public Json.Node to_json_node () {
            var node = new Json.Node (Json.NodeType.OBJECT);
            var json_obj = new Json.Object ();

            json_obj.set_int_member ("id", _id);
            json_obj.set_string_member ("dayPicture", _dayPicture);
            
            var json_array_day = new Json.Array ();
            _scheduleDay.foreach ((hour) => {
                json_array_day.add_int_element (hour);
            });

            var json_array_night = new Json.Array ();
            _scheduleNight.foreach ((hour) => {
                json_array_night.add_int_element (hour);
            });

            json_obj.set_array_member ("schedule_day", json_array_day);
            json_obj.set_array_member ("schedule_night", json_array_night);

            node.set_object (json_obj);
            return node;
        }
    }

    public class Config {
        public Normal? normal { get; set; }
        public Slideshow? slideshow { get; set; }
        public DayNight? dayNight { get; set; }
        public string json_string {
            owned get {
                var json_string = new StringBuilder();
                json_string.append("{");
                if (_normal != null) {
                    json_string.append(@"\"normal\": $(_normal.json_string),");
                }
                
                if (_slideshow != null) {
                    json_string.append(@"\"slideshow\": $(_slideshow.json_string),");
                }
                
                if (_dayNight != null) {
                    json_string.append(@"\"daynight\": $(_dayNight.json_string)");
                }
                json_string.append("}");

                return json_string.str;
            }
        }

        public Config (
            Normal? normal,
            Slideshow? slideshow,
            DayNight? dayNight
        ) {
            _normal = normal;
            _slideshow = slideshow;
            _dayNight = dayNight;
        }

        public static Config? from_json_node (Json.Node json_node) {
            var normal = Normal.from_json_node (json_node);
            var slideshow = Slideshow.from_json_node (json_node);
            var dayNight = DayNight.from_json_node (json_node);

            return new Config (
                normal, 
                slideshow, 
                dayNight
            );
        }

        public Json.Node to_json_node () {
            var node = new Json.Node (Json.NodeType.OBJECT);
            var json_obj = new Json.Object ();

            if (_normal != null) {
                json_obj.set_object_member (
                    "normal", 
                    _normal.to_json_node ().get_object ()
                );
            }

            if (_slideshow != null) {
                json_obj.set_object_member (
                    "slideshow", 
                    _slideshow.to_json_node ().get_object ()
                );
            }

            if (_dayNight != null) {
                json_obj.set_object_member (
                    "day_night", 
                    _dayNight.to_json_node ().get_object ()
                );
            }

            node.set_object (json_obj);
            return node;
        }
    }
}