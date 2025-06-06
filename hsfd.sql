PGDMP  6        
            }           postgres    17.4    17.4 1    ^           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            _           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            `           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            a           1262    5    postgres    DATABASE     n   CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en-US';
    DROP DATABASE postgres;
                     postgres    false            b           0    0    DATABASE postgres    COMMENT     N   COMMENT ON DATABASE postgres IS 'default administrative connection database';
                        postgres    false    4961                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
                     pg_database_owner    false            c           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                        pg_database_owner    false    4            �            1259    24828    firefighters    TABLE     �  CREATE TABLE public.firefighters (
    firefighter_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    rank character varying(50),
    shift character varying(5),
    station_assignment integer,
    status character varying(20),
    hire_date date,
    unit_id integer,
    CONSTRAINT firefighters_shift_check CHECK (((shift)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[]))),
    CONSTRAINT firefighters_status_check CHECK (((status)::text = ANY ((ARRAY['Active'::character varying, 'Retired'::character varying, 'Medical Leave'::character varying])::text[])))
);
     DROP TABLE public.firefighters;
       public         heap r       postgres    false    4            �            1259    24827    firefighters_firefighter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.firefighters_firefighter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.firefighters_firefighter_id_seq;
       public               postgres    false    4    220            d           0    0    firefighters_firefighter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.firefighters_firefighter_id_seq OWNED BY public.firefighters.firefighter_id;
          public               postgres    false    219            �            1259    24854    firefightershifts    TABLE     n   CREATE TABLE public.firefightershifts (
    firefighter_id integer NOT NULL,
    shift_id integer NOT NULL
);
 %   DROP TABLE public.firefightershifts;
       public         heap r       postgres    false    4            �            1259    24875 	   incidents    TABLE        CREATE TABLE public.incidents (
    incident_id integer NOT NULL,
    incident_date date NOT NULL,
    incident_type character varying(50),
    station_id integer,
    description text,
    duration_hours numeric(5,2),
    shift character varying(10),
    CONSTRAINT incidents_duration_hours_check CHECK ((duration_hours > (0)::numeric)),
    CONSTRAINT incidents_incident_type_check CHECK (((incident_type)::text = ANY ((ARRAY['Fire'::character varying, 'Rescue'::character varying, 'Medical'::character varying, 'HazMat'::character varying, 'Alarm'::character varying, 'Other'::character varying])::text[]))),
    CONSTRAINT incidents_shift_check CHECK (((shift)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[])))
);
    DROP TABLE public.incidents;
       public         heap r       postgres    false    4            �            1259    24874    incidents_incident_id_seq    SEQUENCE     �   CREATE SEQUENCE public.incidents_incident_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.incidents_incident_id_seq;
       public               postgres    false    225    4            e           0    0    incidents_incident_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.incidents_incident_id_seq OWNED BY public.incidents.incident_id;
          public               postgres    false    224            �            1259    24891    incidentunits    TABLE     f   CREATE TABLE public.incidentunits (
    incident_id integer NOT NULL,
    unit_id integer NOT NULL
);
 !   DROP TABLE public.incidentunits;
       public         heap r       postgres    false    4            �            1259    24842    shifts    TABLE     d  CREATE TABLE public.shifts (
    shift_id integer NOT NULL,
    shift_name character varying(5),
    station_id integer,
    shift_date date,
    hours integer,
    CONSTRAINT shifts_shift_name_check CHECK (((shift_name)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying, 'Admin'::character varying])::text[])))
);
    DROP TABLE public.shifts;
       public         heap r       postgres    false    4            �            1259    24841    shifts_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shifts_shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.shifts_shift_id_seq;
       public               postgres    false    222    4            f           0    0    shifts_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.shifts_shift_id_seq OWNED BY public.shifts.shift_id;
          public               postgres    false    221            �            1259    24811    stations    TABLE     �   CREATE TABLE public.stations (
    station_id integer NOT NULL,
    name character varying(100) NOT NULL,
    location character varying(250)
);
    DROP TABLE public.stations;
       public         heap r       postgres    false    4            �            1259    24816    units    TABLE     �  CREATE TABLE public.units (
    unit_id integer NOT NULL,
    unit_name character varying(50) NOT NULL,
    type character varying(25),
    station_id integer,
    CONSTRAINT units_type_check CHECK (((type)::text = ANY ((ARRAY['Engine'::character varying, 'Truck'::character varying, 'Rescue'::character varying, 'Boat'::character varying, 'Brush'::character varying, 'ATV'::character varying, 'Haz-Mat'::character varying, 'Dive'::character varying, 'Command'::character varying])::text[])))
);
    DROP TABLE public.units;
       public         heap r       postgres    false    4            �           2604    24831    firefighters firefighter_id    DEFAULT     �   ALTER TABLE ONLY public.firefighters ALTER COLUMN firefighter_id SET DEFAULT nextval('public.firefighters_firefighter_id_seq'::regclass);
 J   ALTER TABLE public.firefighters ALTER COLUMN firefighter_id DROP DEFAULT;
       public               postgres    false    220    219    220            �           2604    24878    incidents incident_id    DEFAULT     ~   ALTER TABLE ONLY public.incidents ALTER COLUMN incident_id SET DEFAULT nextval('public.incidents_incident_id_seq'::regclass);
 D   ALTER TABLE public.incidents ALTER COLUMN incident_id DROP DEFAULT;
       public               postgres    false    225    224    225            �           2604    24845    shifts shift_id    DEFAULT     r   ALTER TABLE ONLY public.shifts ALTER COLUMN shift_id SET DEFAULT nextval('public.shifts_shift_id_seq'::regclass);
 >   ALTER TABLE public.shifts ALTER COLUMN shift_id DROP DEFAULT;
       public               postgres    false    221    222    222            U          0    24828    firefighters 
   TABLE DATA           �   COPY public.firefighters (firefighter_id, first_name, last_name, rank, shift, station_assignment, status, hire_date, unit_id) FROM stdin;
    public               postgres    false    220   B       X          0    24854    firefightershifts 
   TABLE DATA           E   COPY public.firefightershifts (firefighter_id, shift_id) FROM stdin;
    public               postgres    false    223   �G       Z          0    24875 	   incidents 
   TABLE DATA           ~   COPY public.incidents (incident_id, incident_date, incident_type, station_id, description, duration_hours, shift) FROM stdin;
    public               postgres    false    225   JH       [          0    24891    incidentunits 
   TABLE DATA           =   COPY public.incidentunits (incident_id, unit_id) FROM stdin;
    public               postgres    false    226   \J       W          0    24842    shifts 
   TABLE DATA           U   COPY public.shifts (shift_id, shift_name, station_id, shift_date, hours) FROM stdin;
    public               postgres    false    222   K       R          0    24811    stations 
   TABLE DATA           >   COPY public.stations (station_id, name, location) FROM stdin;
    public               postgres    false    217   �K       S          0    24816    units 
   TABLE DATA           E   COPY public.units (unit_id, unit_name, type, station_id) FROM stdin;
    public               postgres    false    218   +L       g           0    0    firefighters_firefighter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.firefighters_firefighter_id_seq', 76, true);
          public               postgres    false    219            h           0    0    incidents_incident_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.incidents_incident_id_seq', 26, true);
          public               postgres    false    224            i           0    0    shifts_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.shifts_shift_id_seq', 22, true);
          public               postgres    false    221            �           2606    24835    firefighters firefighters_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_pkey PRIMARY KEY (firefighter_id);
 H   ALTER TABLE ONLY public.firefighters DROP CONSTRAINT firefighters_pkey;
       public                 postgres    false    220            �           2606    24858 (   firefightershifts firefightershifts_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_pkey PRIMARY KEY (firefighter_id, shift_id);
 R   ALTER TABLE ONLY public.firefightershifts DROP CONSTRAINT firefightershifts_pkey;
       public                 postgres    false    223    223            �           2606    24884    incidents incidents_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (incident_id);
 B   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_pkey;
       public                 postgres    false    225            �           2606    24895     incidentunits incidentunits_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_pkey PRIMARY KEY (incident_id, unit_id);
 J   ALTER TABLE ONLY public.incidentunits DROP CONSTRAINT incidentunits_pkey;
       public                 postgres    false    226    226            �           2606    24848    shifts shifts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (shift_id);
 <   ALTER TABLE ONLY public.shifts DROP CONSTRAINT shifts_pkey;
       public                 postgres    false    222            �           2606    24815    stations stations_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (station_id);
 @   ALTER TABLE ONLY public.stations DROP CONSTRAINT stations_pkey;
       public                 postgres    false    217            �           2606    24821    units units_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unit_id);
 :   ALTER TABLE ONLY public.units DROP CONSTRAINT units_pkey;
       public                 postgres    false    218            �           2606    24836 1   firefighters firefighters_station_assignment_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_station_assignment_fkey FOREIGN KEY (station_assignment) REFERENCES public.stations(station_id);
 [   ALTER TABLE ONLY public.firefighters DROP CONSTRAINT firefighters_station_assignment_fkey;
       public               postgres    false    220    217    4779            �           2606    24906 &   firefighters firefighters_unit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.firefighters
    ADD CONSTRAINT firefighters_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);
 P   ALTER TABLE ONLY public.firefighters DROP CONSTRAINT firefighters_unit_id_fkey;
       public               postgres    false    220    218    4781            �           2606    24859 7   firefightershifts firefightershifts_firefighter_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_firefighter_id_fkey FOREIGN KEY (firefighter_id) REFERENCES public.firefighters(firefighter_id);
 a   ALTER TABLE ONLY public.firefightershifts DROP CONSTRAINT firefightershifts_firefighter_id_fkey;
       public               postgres    false    220    223    4783            �           2606    24864 1   firefightershifts firefightershifts_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.firefightershifts
    ADD CONSTRAINT firefightershifts_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shifts(shift_id);
 [   ALTER TABLE ONLY public.firefightershifts DROP CONSTRAINT firefightershifts_shift_id_fkey;
       public               postgres    false    4785    223    222            �           2606    24885 #   incidents incidents_station_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);
 M   ALTER TABLE ONLY public.incidents DROP CONSTRAINT incidents_station_id_fkey;
       public               postgres    false    225    217    4779            �           2606    24896 ,   incidentunits incidentunits_incident_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_incident_id_fkey FOREIGN KEY (incident_id) REFERENCES public.incidents(incident_id);
 V   ALTER TABLE ONLY public.incidentunits DROP CONSTRAINT incidentunits_incident_id_fkey;
       public               postgres    false    225    4789    226            �           2606    24901 (   incidentunits incidentunits_unit_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.incidentunits
    ADD CONSTRAINT incidentunits_unit_id_fkey FOREIGN KEY (unit_id) REFERENCES public.units(unit_id);
 R   ALTER TABLE ONLY public.incidentunits DROP CONSTRAINT incidentunits_unit_id_fkey;
       public               postgres    false    226    4781    218            �           2606    24849    shifts shifts_station_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);
 G   ALTER TABLE ONLY public.shifts DROP CONSTRAINT shifts_station_id_fkey;
       public               postgres    false    222    4779    217            �           2606    24822    units units_station_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_station_id_fkey FOREIGN KEY (station_id) REFERENCES public.stations(station_id);
 E   ALTER TABLE ONLY public.units DROP CONSTRAINT units_station_id_fkey;
       public               postgres    false    218    217    4779            U   �  x��W�v�H}.}���V�Ȓe��x���˼4�1=j��!_?�0j!O^���ZnU�B����;�ni�UzC�r�k4Y���"Q�Q���D(��͎�*i�4����V�!P1
�(� �����'���*�3V�W����e�҄�*
�pF���8H苪�#ͤm���Voڻ���d]�����	�C�R�,wZ�����Jx�R�g#�	�ph?�E:qM)��H��9 \��i���&������jLS�Z��V����Dp�bLIP �*/[c��yL�<�#�b�l�-}�u��(���n!m��U� SW��#������V
Y�-��ɤ�+�Dtr�l�Z]C�y�����41�k�&�j�����W�2�	�O��c���ǣ(u�)�*�|��4UyC�MXŅ��[��T�lۥe�џ����K���Ǖj�k��@JY 2�z+mI5b�h�0Ϩ���>�@�`V�I�N`��v� � �j1��+i�n�B�<��q���z
^J��`2d_$�o@�X��Y*�+��_��صs���Ѳ�b_?��u�F?m�>�Qĭ#fL��X�\榖(r6��Y��1gYA���[���V���c��yH���̐���E��{k��]�{)��ymV� �u��l�8X�B�ك�hГ�䭧�3��fs��!�ԭcg��`�C�;�d=}�:�O��z�Y5�Og�<C�?a��U��^���T��w���{�x�&<�I�/��fc�wX���� �> �<�QF�J>��;Uw���ǧm�A�y��6��n��!"�<���6���"���t]8�`=�:l����M7��C�t��7�n1lN7vJ�~@��FEH:��^�kD���Q�=A؏�ΠZ�q�7�)�F��Tf�&Z�z��s��;�2��� ��Լ30��$��:b�n��ٸ^��w�ȝ@9Q�/�>���o��'�x?�{��Wum)O���=�H)0�mK����Ij�)��	�2oc��ӹoZ�ѓ���\��i���7q$lʬ�`t��ֵ���o���9v]�P�z&1��zm9^5v��י'A�����LWX�I�7�9_n�dS�N��c��|�a�0<��'e�?fQ��B�p�$9^��,��r٧A2�YR(pUw����������>gq���b�q��Q��S'�T�R�x��k+½�i+�:b��W�ܑZ����[�}Q�&S���'�� ,�T4�䗞�7 P�}���ee�m�������N�jcy�N':wH��"���v��o����׀aN�Գ!Oa�4��*7�����W��I�x�e!G�r�U����)S�	gTd��M�yؕ��f��k��	t��.��z��r=����7+�Q����	/���珌τ��y��y�C\�� cq��U��0�@n�(���0��`�ł �Z��sz]�,��]��� P      X   Z   x�M��0z�0��h�]���>� ���9ʈ��/	N�XDKđ+�P�I���啅�,��������Xj+�!�T��螯��} �      Z     x���Mn�0���)x"�g/]F�0RDm�醕&�4H�@r��8�-6h��|�7o����j�����vO�v�1���yڃ��KT�$-��.oȧ��ٚ�+��K�/Hm�r��2Ŕ�A/;����<=��z+�;�d�d9�V�oV��nQb��������T?F�`{� �,_!V_0�����(e�a���=h�|y�7�͔?�e�]y
�P���l�e�)#?�t��n�)k8��y��n�!�cF��޹�<
/��^|���6d'5���5������^(�݇�g�V̵2���KM��Zss���$?�=�_G�9��	olj�:cՔ�� w�V�I/��Yp)�Eި��7���9W��H�mv#tJAOASkF������s��%�ō�*�_��������a�����H�VK�;L��M�Ua�b{
YyJ�l�%����H����x�N��_^�jA��6ux�4�D1�'M,:R�J�95e8x?�,�c���      [   �   x�-P�!{K17�^��:.�}!A�����#��i(
,1��i��.z���q���Āe��9��ԧ��-��钾�}���I�Ǽ,@�j}u��{=��"8L<Zi�9QZJkc|� 0�73�"� /p�w�:8u���������*�      W   �   x�e�;�0�Z�K���)C�AIC�/Y����VZ�;	iѺߤ�:+̒̓9lOVa-�N����Ĝ΍���7�a��y2,���l�?]�.F�j:�h+�3�����2�X�<b��Ē'Jly�ƚ>n��`K�      R   }   x�=˱
�0 ���+�B�4�kUp� vu9hĐ��5����C���p	�
�`uGg)����*�0W��d��݉�,��=(�����1ʧH�Ǣph6�1M���.�*
}S�jM���h�9m��T���*'      S   �   x�U�A
�0E�N�H'3�{���nJ-*�-��S�����O��x�)p0�;�;(���R��q[���n�r��ۜ?�<��/e��M�6&�:�c�8����XqZ����\-�֡U�Z�V=b{�2b{�2�����DW�     