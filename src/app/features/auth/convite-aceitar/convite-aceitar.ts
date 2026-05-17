import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { NotificationService } from '../../../core/services/notification.service';

@Component({
  selector: 'app-convite-aceitar',
  standalone: true,
  imports: [],
  templateUrl: './convite-aceitar.html',
  styleUrls: ['./convite-aceitar.scss'],
})
export class ConviteAceitarComponent implements OnInit {
  private route = inject(ActivatedRoute);
  private router = inject(Router);
  private auth = inject(AuthService);
  private notification = inject(NotificationService);

  ngOnInit(): void {
    const token = this.route.snapshot.queryParamMap.get('token') ?? '';

    if (!token) {
      this.notification.set({ text: 'Token do convite não encontrado.', type: 'error' });
      this.router.navigate(['/login']);
      return;
    }

    this.auth.verifyEmail(token).subscribe({
      next: (res) => {
        this.notification.set({ text: res.message || 'Acesso liberado com sucesso!', type: 'success' });
        this.router.navigate(['/login']);
      },
      error: (err) => {
        this.notification.set({ text: err?.error?.message ?? 'Token inválido ou expirado.', type: 'error' });
        this.router.navigate(['/login']);
      },
    });
  }
}
