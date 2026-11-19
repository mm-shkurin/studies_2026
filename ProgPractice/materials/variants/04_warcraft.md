# Вариант №4. Warcraft / World of Warcraft

<!-- path: disciplines/programming-workshop-bachelors-5sem/variants/4; updated-at: 2026-09-15T09:15:40.977Z; author-name: Иван Бугаенко -->

Источник: https://wiki.pmifi.ru

![Шапка страницы](https://i.playground.ru/e/wgoXPG9CtjzeyzGL9-8HIw.jpeg)

## [¶](#мемо-встречи-с-заказчиком) МЕМО встречи с заказчиком

> Ссылка на датасет: <https://drive.google.com/file/d/1OzFhx_yDSGPNr_yUgRg1XEMYSmphs5Pp/view?usp=sharing>

После того как от земель Лордерона отступила чума, Отрекшиеся решили заняться обычными крестьянскими делами — восстановлением хозяйства и сбором урожая для торговли. Леса Лордерона издавна славились своими грибами, однако чума не прошла для них бесследно: многие грибы изменились и стали непригодны для употребления.

Чтобы не рисковать урожаем и не допустить попадания опасных грибов на рынки, травники Отрекшихся начали внимательно исследовать найденные экземпляры. Для каждого гриба они записывали его внешний вид, размеры, форму и цвет различных частей, место произрастания и другие характеристики.

Так травники собрали большой датасет грибов Лордерона. Теперь необходимо помочь им определить, какие грибы пригодны для сбора и торговли, а какие после воздействия чумы стали опасными.

> **Калия Менетилл, член Мрачносовета**  
> — Многое из того, что было известно нашим травникам о землях Лордерона, погибло вместе с Третьей войной. Старые записи сгорели, архивы были разграблены, а те, кто хранил эти знания, погибли или покинули наши земли. Поэтому собрать полную информацию о грибах Лордерона нам так и не удалось. Некоторые характеристики удалось восстановить по сохранившимся записям, другие травники определяли самостоятельно, а о некоторых экземплярах сведений и вовсе не осталось. Теперь нам предстоит разобраться с тем, что удалось собрать, и понять, какие знания все еще можно восстановить. Да хранит нас Свет.

## [¶](#дополнительные-сведения-о-данных) Дополнительные сведения о данных

Class information:

1. class poisonous=p, edibile=e (binary)

Variable Information (n: nominal, m: metrical; nominal values as sets of values):

1. cap-diameter (m): float number in cm
2. cap-shape (n): bell=b, conical=c, convex=x, flat=f, sunken=s, spherical=p, others=o
3. cap-surface (n): fibrous=i, grooves=g, scaly=y, smooth=s, shiny=h, leathery=l, silky=k, sticky=t, wrinkled=w, fleshy=e
4. cap-color (n): brown=n, buff=b, gray=g, green=r, pink=p, purple=u, red=e, white=w, yellow=y, blue=l, orange=o, black=k
5. does-bruise-bleed (n): bruises-or-bleeding=t,no=f
6. gill-attachment (n): adnate=a, adnexed=x, decurrent=d, free=e, sinuate=s, pores=p, none=f, unknown=?
7. gill-spacing (n): close=c, distant=d, none=f
8. gill-color (n): see cap-color + none=f
9. stem-height (m): float number in cm
10. stem-width (m): float number in mm
11. stem-root (n): bulbous=b, swollen=s, club=c, cup=u, equal=e, rhizomorphs=z, rooted=r
12. stem-surface (n): see cap-surface + none=f
13. stem-color (n): see cap-color + none=f
14. veil-type (n): partial=p, universal=u
15. veil-color (n): see cap-color + none=f
16. has-ring (n): ring=t, none=f
17. ring-type (n): cobwebby=c, evanescent=e, flaring=r, grooved=g, large=l, pendant=p, sheathing=s, zone=z, scaly=y, movable=m, none=f, unknown=?
18. spore-print-color (n): see cap color
19. habitat (n): grasses=g, leaves=l, meadows=m, paths=p, heaths=h, urban=u, waste=w, woods=d
20. season (n): spring=s, summer=u, autumn=a, winter=w
