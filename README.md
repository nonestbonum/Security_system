- PostgreSQL

- Java JDBC

1) Требуется разработать структуру Базы Данных для обеспечения хранения данных системы.

2) Реализовать типовой функционал добавления/редактирования/удаления данных о сигналах и датчиках.

    - insertDetectorNotFullCharge(String serial_number, String installation_location, double charge_lvl, int status) 
    - insertDetectorWthFullCharge(String serial_number, String installation_location, int status)
    - deleteDetector(String serial_number)
    - changeDetector(String serial_number, String installation_location, double charge_lvl, int status)

    - insertSignal(String signal_time, String detector_serial_number, int type_of_signal)
    - deleteSignal(String signal_time, String detector_serial_number, int type_of_signal)
    - changeSignal(int id, String signal_time, String detector_serial_number, int type_of_signal)
   
3) Реализовать хранение истории данных о датчиках с указанием кто вносил изменение данных (текстовая
   строка имени пользователя, вносившего изменения).

    - См. "история данных о датчиках"
    - logs.sql

4) Реализовать функцию приема сигнала от датчика. Сигнал приходит в виде строки по шаблону: <номер
   датчика>|<тип сигнала>|<служебная информация>. Тип сигнала может быть 1 – тревога, 2 – служебный сигнал.
   В служебной информации может передаваться уровень заряда батареи в процентах.

    - receive_signal(String text)
   
5) Реализовать запрос отчета «Информация о датчике на заданную дату».

   - get_info_about_detector_per_date(String str_date)

6) Реализовать запрос отчета «Информация о сигналах датчиков за заданный период времени».

    - get_info_about_signals_per_interval(String first_time, String second_time)

7) Реализовать защиту изменения данных в таблицах. Только реализуемые функции имеют возможность
   изменять данные.

    - Для этого все функции вызываются из слоя Java, чтобы не было возможности напрямую вносить изменения через запросы.
    

    