<footer id="contact" class="pt-16 pb-10 border-t border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-950">
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
    <div class="grid md:grid-cols-4 gap-10">
      <div>
        <div class="flex items-center gap-2">
            <span class="inline-grid h-9 w-9 place-items-center rounded-xl bg-gradient-to-br from-brand-500 to-brand-700 text-white shadow-soft">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" class="h-5 w-5" fill="currentColor"><path d="M7.5 7.5a2 2 0 1 1-4 0 2 2 0 0 1 4 0Zm6-1a2.2 2.2 0 1 1-4.4 0 2.2 2.2 0 0 1 4.4 0Zm7 3a2 2 0 1 1-4 0 2 2 0 0 1 4 0ZM6 14.5c0-2.3 2.6-3.7 6-3.7s6 1.4 6 3.7c0 2-2.7 4-6 4s-6-2-6-4Z"/></svg>
            </span>
          <span class="font-display text-lg">Happy Paws <span class="text-brand-700">PetCare</span></span>
        </div>
        <p class="mt-3 text-sm text-slate-600 dark:text-slate-300">Modern veterinary & grooming for happier, healthier pets.</p>
      </div>
      <div>
        <h4 class="font-semibold">Clinic</h4>
        <ul class="mt-3 space-y-2 text-sm text-slate-600 dark:text-slate-300">
          <li>123 Paw Street, Colombo</li>
          <li>+94 77 123 4567</li>
          <li>hello@happypawspetcare.com</li>
        </ul>
      </div>
      <div>
        <h4 class="font-semibold">Links</h4>
        <ul class="mt-3 space-y-2 text-sm text-slate-600 dark:text-slate-300">
          <li><a href="#features" class="hover:text-brand-700">Features</a></li>
          <li><a href="#services" class="hover:text-brand-700">Services</a></li>
          <li><a href="#booking" class="hover:text-brand-700">Book</a></li>
          <li><a href="#reviews" class="hover:text-brand-700">Reviews</a></li>
        </ul>
      </div>
      <div>
        <h4 class="font-semibold">Newsletter</h4>
        <p class="mt-2 text-sm text-slate-600 dark:text-slate-300">Get tips, offers, and updates.</p>
        <form onsubmit="event.preventDefault(); handleSubscribe();" class="mt-3 flex gap-2">
          <input id="emailSub" type="email" required placeholder="you@example.com" class="flex-1 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 px-3 py-2" />
          <button class="px-4 py-2 rounded-xl bg-slate-900 dark:bg-white text-white dark:text-slate-900 font-medium">Join</button>
        </form>
        <p id="subMsg" class="mt-2 hidden text-emerald-700 dark:text-emerald-400 text-sm">Subscribed! 🎉</p>
      </div>
    </div>
    <div class="mt-10 pt-6 border-t border-slate-200 dark:border-slate-800 text-xs text-slate-500 flex items-center justify-between">
      <p>&copy;<span id="year"></span> Happy Paws PetCare. All rights reserved.</p>
      <a href="#" class="hover:text-brand-700">Privacy Terms</a>
    </div>
  </div>
</footer>